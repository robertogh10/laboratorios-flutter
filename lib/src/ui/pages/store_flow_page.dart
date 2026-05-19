import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/state/store_state.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/bag_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/checkout_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/product_detail_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/store_home_view.dart';

class StoreFlowPage extends ConsumerWidget {
  const StoreFlowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeControllerProvider);
    final controller = ref.read(storeControllerProvider.notifier);

    return switch (state.view) {
      StoreView.home => StoreHomeView(
        products: state.products,
        bagCount: controller.bagCount,
        onProductPressed: controller.openProduct,
        onBagPressed: controller.openBag,
      ),
      StoreView.detail => ProductDetailView(
        product: controller.selectedProduct,
        onClose: controller.openHome,
        onFavoritePressed: () {},
        onAddToBag: controller.addSelectedProductToBag,
      ),
      StoreView.bag => BagView(
        items: state.bagItems,
        total: controller.total,
        onBack: controller.openHome,
        onIncrement: controller.incrementItem,
        onDecrement: controller.decrementItem,
        onCheckout: controller.openCheckout,
      ),
      StoreView.checkout => CheckoutView(
        methods: state.paymentMethods,
        selectedMethodId: state.selectedPaymentMethodId,
        billingSameAsShipping: state.billingSameAsShipping,
        onCancel: controller.openBag,
        onMethodPressed: controller.selectPaymentMethod,
        onBillingPressed: controller.toggleBillingSameAsShipping,
        onContinue: () {},
      ),
    };
  }
}
