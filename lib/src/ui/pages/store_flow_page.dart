import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/bag_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/checkout_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/product_detail_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/store_home_view.dart';

enum StoreRouteView { home, detail, bag, checkout }

class StoreFlowPage extends ConsumerWidget {
  const StoreFlowPage({required this.view, this.productId, super.key});

  final StoreRouteView view;
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeControllerProvider);
    final controller = ref.read(storeControllerProvider.notifier);

    return Scaffold(
      body: switch (view) {
        StoreRouteView.home => StoreHomeView(
          products: state.products,
          bagCount: controller.bagCount,
          onProductPressed: (id) => context.go(AppRoutes.storeProduct(id)),
          onBagPressed: () => context.go(AppRoutes.storeBag),
        ),
        StoreRouteView.detail => ProductDetailView(
          product: controller.productById(productId ?? state.selectedProductId),
          onClose: () => context.go(AppRoutes.storeHome),
          onFavoritePressed: () {},
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
          onCheckout: () => context.go(AppRoutes.storeCheckout),
        ),
        StoreRouteView.checkout => CheckoutView(
          methods: state.paymentMethods,
          selectedMethodId: state.selectedPaymentMethodId,
          billingSameAsShipping: state.billingSameAsShipping,
          onCancel: () => context.go(AppRoutes.storeBag),
          onMethodPressed: controller.selectPaymentMethod,
          onBillingPressed: controller.toggleBillingSameAsShipping,
          onContinue: () {},
        ),
      },
    );
  }
}
