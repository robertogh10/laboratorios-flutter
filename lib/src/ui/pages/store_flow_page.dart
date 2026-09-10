import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/auth_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/sales_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/add_card_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/bag_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/checkout_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/product_detail_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/sales_stream_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/store_home_view.dart';

enum StoreRouteView { home, detail, bag, sales, checkout, addCard }

class StoreFlowPage extends ConsumerWidget {
  const StoreFlowPage({required this.view, this.productId, super.key});

  final StoreRouteView view;
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(storeControllerProvider);
    final authSession = ref.watch(authSessionProvider);
    final sales = ref.watch(salesStreamProvider);
    final checkoutState = ref.watch(salesControllerProvider);
    final controller = ref.read(storeControllerProvider.notifier);
    final isAdmin = authSession.maybeWhen(
      data: (session) => session?.isAdmin ?? false,
      orElse: () => false,
    );

    return Scaffold(
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _StoreErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(storeControllerProvider),
        ),
        data: (state) => switch (view) {
          StoreRouteView.home => StoreHomeView(
            products: state.products,
            bagCount: controller.bagCount,
            isAdmin: isAdmin,
            onProductPressed: (id) {
              controller.selectProduct(id);
              context.go(AppRoutes.storeProduct(id));
            },
            onSignOut: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              ref.invalidate(salesStreamProvider);

              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            onBagPressed: () => context.go(AppRoutes.storeBag),
            onSalesPressed: () => context.go(AppRoutes.storeSales),
            onProfilePressed: () => context.go(AppRoutes.storeProfile),
            onAddProductPressed: () => context.go(AppRoutes.storeNewProduct),
          ),
          StoreRouteView.detail => ProductDetailView(
            product: controller.productById(
              productId ?? state.selectedProductId,
            ),
            isAdmin: isAdmin,
            onClose: () => context.go(AppRoutes.storeHome),
            onFavoritePressed: () {},
            onEditPressed: () {
              context.go(
                AppRoutes.storeEditProduct(
                  productId ?? state.selectedProductId,
                ),
              );
            },
            onSizeSelected: (size) {
              controller.selectProductSize(
                productId ?? state.selectedProductId,
                size,
              );
            },
            onColorSelected: (color) {
              controller.selectProductColor(
                productId ?? state.selectedProductId,
                color,
              );
            },
            onAddToBag: () {
              controller.addProductToBag(productId ?? state.selectedProductId);
              context.go(AppRoutes.storeBag);
            },
          ),
          StoreRouteView.bag => BagView(
            items: state.bagItems,
            total: controller.total,
            onBack: () => context.go(AppRoutes.storeHome),
            onIncrement: controller.incrementItem,
            onDecrement: controller.decrementItem,
            onRemove: controller.removeItem,
            onCheckout: () => context.go(AppRoutes.storeCheckout),
          ),
          StoreRouteView.sales => SalesStreamView(
            sales: sales,
            isAdmin: isAdmin,
            onBack: () => context.go(AppRoutes.storeHome),
            onRetry: () => ref.invalidate(salesStreamProvider),
          ),
          StoreRouteView.checkout => CheckoutView(
            methods: state.paymentMethods,
            selectedMethodId: state.selectedPaymentMethodId,
            billingSameAsShipping: state.billingSameAsShipping,
            onCancel: () => context.go(AppRoutes.storeBag),
            onMethodPressed: controller.selectPaymentMethod,
            onBillingPressed: controller.toggleBillingSameAsShipping,
            onAddNewCard: () => context.go(AppRoutes.storeAddCard),
            continuing: checkoutState.isLoading,
            onContinue: () async {
              final completed = await ref
                  .read(salesControllerProvider.notifier)
                  .checkout();

              if (!context.mounted) {
                return;
              }

              if (completed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compra registrada.')),
                );
                context.go(AppRoutes.storeSales);
                return;
              }

              final error = ref
                  .read(salesControllerProvider)
                  .whenOrNull(error: (error, stackTrace) => error.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error ?? 'No se pudo completar la compra.'),
                ),
              );
            },
          ),
          StoreRouteView.addCard => AddCardView(
            onCancel: () => context.go(AppRoutes.storeCheckout),
            onSave: (details) {
              controller.addPaymentCard(
                cardholderName: details.cardholderName,
                cardNumber: details.cardNumber,
                expiryDate: details.expiryDate,
              );
              context.go(AppRoutes.storeCheckout);
            },
          ),
        },
      ),
    );
  }
}

class _StoreErrorView extends StatelessWidget {
  const _StoreErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No se pudo cargar la tienda',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
