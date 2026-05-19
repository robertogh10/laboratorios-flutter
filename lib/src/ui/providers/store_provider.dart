import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/repositories/store_repository_impl.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_bag_items.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_payment_methods.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_products.dart';
import 'package:laboratorio_experinece_app/src/ui/state/store_state.dart';

final storeLocalDataSourceProvider = Provider<StoreLocalDataSource>((ref) {
  return const StoreLocalDataSource();
});

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepositoryImpl(ref.watch(storeLocalDataSourceProvider));
});

final getProductsProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.watch(storeRepositoryProvider));
});

final getBagItemsProvider = Provider<GetBagItems>((ref) {
  return GetBagItems(ref.watch(storeRepositoryProvider));
});

final getPaymentMethodsProvider = Provider<GetPaymentMethods>((ref) {
  return GetPaymentMethods(ref.watch(storeRepositoryProvider));
});

final storeControllerProvider = NotifierProvider<StoreController, StoreState>(
  StoreController.new,
);

class StoreController extends Notifier<StoreState> {
  @override
  StoreState build() {
    final products = ref.watch(getProductsProvider)();
    final paymentMethods = ref.watch(getPaymentMethodsProvider)();

    return StoreState(
      view: StoreView.home,
      products: products,
      bagItems: ref.watch(getBagItemsProvider)(),
      paymentMethods: paymentMethods,
      selectedProductId: products.first.id,
      selectedPaymentMethodId: paymentMethods.first.id,
      billingSameAsShipping: true,
    );
  }

  Product get selectedProduct {
    return state.products.firstWhere(
      (product) => product.id == state.selectedProductId,
    );
  }

  double get total {
    return state.bagItems.fold<double>(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  int get bagCount {
    return state.bagItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  void openHome() {
    state = state.copyWith(view: StoreView.home);
  }

  void openProduct(String id) {
    state = state.copyWith(view: StoreView.detail, selectedProductId: id);
  }

  void openBag() {
    state = state.copyWith(view: StoreView.bag);
  }

  void openCheckout() {
    state = state.copyWith(view: StoreView.checkout);
  }

  void addSelectedProductToBag() {
    final product = selectedProduct;
    final exists = state.bagItems.any((item) => item.product.id == product.id);
    final bagItems = exists
        ? state.bagItems.map((item) {
            if (item.product.id != product.id) {
              return item;
            }

            return item.copyWith(quantity: item.quantity + 1);
          }).toList()
        : [...state.bagItems, BagItem(product: product, quantity: 1)];

    state = state.copyWith(bagItems: bagItems, view: StoreView.bag);
  }

  void incrementItem(String id) {
    final bagItems = state.bagItems.map((item) {
      if (item.product.id != id) {
        return item;
      }

      return item.copyWith(quantity: item.quantity + 1);
    }).toList();

    state = state.copyWith(bagItems: bagItems);
  }

  void decrementItem(String id) {
    final bagItems = state.bagItems.map((item) {
      if (item.product.id != id || item.quantity == 1) {
        return item;
      }

      return item.copyWith(quantity: item.quantity - 1);
    }).toList();

    state = state.copyWith(bagItems: bagItems);
  }

  void selectPaymentMethod(String id) {
    final method = state.paymentMethods.firstWhere((item) => item.id == id);

    if (!method.enabled) {
      return;
    }

    state = state.copyWith(selectedPaymentMethodId: id);
  }

  void toggleBillingSameAsShipping() {
    state = state.copyWith(billingSameAsShipping: !state.billingSameAsShipping);
  }
}
