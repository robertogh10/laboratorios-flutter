import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_firebase_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/repositories/store_repository_impl.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_bag_items.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_payment_methods.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_products.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/save_bag_items.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/save_payment_methods.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/save_product.dart';
import 'package:laboratorio_experinece_app/src/ui/state/store_state.dart';

final firebaseEnabledProvider = Provider<bool>((ref) => false);

final storeLocalDataSourceProvider = Provider<StoreLocalDataSource>((ref) {
  return StoreLocalDataSource();
});

final storeFirebaseDataSourceProvider = Provider<StoreFirebaseDataSource>((
  ref,
) {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo-user';

  return StoreFirebaseDataSource(
    fallbackDataSource: ref.watch(storeLocalDataSourceProvider),
    userId: userId,
  );
});

final storeDataSourceProvider = Provider<StoreDataSource>((ref) {
  if (ref.watch(firebaseEnabledProvider)) {
    return ref.watch(storeFirebaseDataSourceProvider);
  }

  return ref.watch(storeLocalDataSourceProvider);
});

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepositoryImpl(ref.watch(storeDataSourceProvider));
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

final saveBagItemsProvider = Provider<SaveBagItems>((ref) {
  return SaveBagItems(ref.watch(storeRepositoryProvider));
});

final savePaymentMethodsProvider = Provider<SavePaymentMethods>((ref) {
  return SavePaymentMethods(ref.watch(storeRepositoryProvider));
});

final saveProductProvider = Provider<SaveProduct>((ref) {
  return SaveProduct(ref.watch(storeRepositoryProvider));
});

final storeControllerProvider =
    AsyncNotifierProvider<StoreController, StoreState>(StoreController.new);

class StoreController extends AsyncNotifier<StoreState> {
  @override
  Future<StoreState> build() async {
    final products = await ref.watch(getProductsProvider)();
    final paymentMethods = await ref.watch(getPaymentMethodsProvider)();

    return StoreState(
      products: products,
      bagItems: await ref.watch(getBagItemsProvider)(),
      paymentMethods: paymentMethods,
      selectedProductId: products.isEmpty ? '' : products.first.id,
      selectedPaymentMethodId: paymentMethods.isEmpty
          ? ''
          : paymentMethods.first.id,
      billingSameAsShipping: true,
    );
  }

  StoreState? get _currentState {
    return state.asData?.value;
  }

  Product get selectedProduct {
    final current = state.requireValue;

    return productById(current.selectedProductId);
  }

  Product productById(String id) {
    return _productById(state.requireValue, id);
  }

  double get total {
    final current = _currentState;

    if (current == null) {
      return 0;
    }

    return current.bagItems.fold<double>(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  int get bagCount {
    final current = _currentState;

    if (current == null) {
      return 0;
    }

    return current.bagItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  void addSelectedProductToBag() {
    final current = _currentState;

    if (current == null) {
      return;
    }

    addProductToBag(current.selectedProductId);
  }

  void addProductToBag(String productId) {
    final current = _currentState;

    if (current == null || current.products.isEmpty) {
      return;
    }

    final product = _productById(current, productId);
    final bagProduct = _productForBag(product);
    final exists = current.bagItems.any(
      (item) => item.product.id == bagProduct.id,
    );
    final bagItems = exists
        ? current.bagItems.map((item) {
            if (item.product.id != bagProduct.id) {
              return item;
            }

            return item.copyWith(quantity: item.quantity + 1);
          }).toList()
        : [...current.bagItems, BagItem(product: bagProduct, quantity: 1)];

    _updateBagItems(current, bagItems);
  }

  void selectProduct(String id) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    _setStoreState(current.copyWith(selectedProductId: id));
  }

  void selectProductSize(String productId, String size) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    _setStoreState(
      current.copyWith(
        products: current.products.map((product) {
          if (product.id != productId || !product.sizes.contains(size)) {
            return product;
          }

          return product.copyWith(selectedSize: size);
        }).toList(),
      ),
    );
  }

  void selectProductColor(String productId, int color) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    _setStoreState(
      current.copyWith(
        products: current.products.map((product) {
          if (product.id != productId || !product.colors.contains(color)) {
            return product;
          }

          return product.copyWith(selectedColor: color);
        }).toList(),
      ),
    );
  }

  void incrementItem(String id) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    final bagItems = current.bagItems.map((item) {
      if (item.product.id != id) {
        return item;
      }

      return item.copyWith(quantity: item.quantity + 1);
    }).toList();

    _updateBagItems(current, bagItems);
  }

  void decrementItem(String id) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    final bagItems = current.bagItems.map((item) {
      if (item.product.id != id || item.quantity == 1) {
        return item;
      }

      return item.copyWith(quantity: item.quantity - 1);
    }).toList();

    _updateBagItems(current, bagItems);
  }

  void removeItem(String id) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    final bagItems = current.bagItems
        .where((item) => item.product.id != id)
        .toList();

    _updateBagItems(current, bagItems);
  }

  void selectPaymentMethod(String id) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    final method = current.paymentMethods.firstWhere((item) => item.id == id);

    if (!method.enabled) {
      return;
    }

    _setStoreState(current.copyWith(selectedPaymentMethodId: id));
  }

  void addPaymentCard({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
  }) {
    final current = _currentState;

    if (current == null) {
      return;
    }

    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    final lastFour = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits.padLeft(4, '0');
    final maskedNumber = 'xxxx xxxx xxxx $lastFour';
    final holder = cardholderName.trim();
    final method = PaymentMethod(
      id: 'card-${DateTime.now().microsecondsSinceEpoch}',
      title: _cardBrand(digits),
      subtitle: holder.isEmpty
          ? '$maskedNumber - $expiryDate'
          : '$maskedNumber - $holder - $expiryDate',
      enabled: true,
    );
    final applePayIndex = current.paymentMethods.indexWhere(
      (item) => item.id == 'apple-pay',
    );
    final paymentMethods = <PaymentMethod>[...current.paymentMethods];

    if (applePayIndex == -1) {
      paymentMethods.add(method);
    } else {
      paymentMethods.insert(applePayIndex, method);
    }

    _updatePaymentMethods(
      current,
      paymentMethods,
      selectedPaymentMethodId: method.id,
    );
  }

  void toggleBillingSameAsShipping() {
    final current = _currentState;

    if (current == null) {
      return;
    }

    _setStoreState(
      current.copyWith(billingSameAsShipping: !current.billingSameAsShipping),
    );
  }

  Future<void> saveProduct(Product product) async {
    final current = _currentState;

    if (current == null) {
      return;
    }

    await ref.read(saveProductProvider)(product);

    final exists = current.products.any((item) => item.id == product.id);
    final products = exists
        ? current.products.map((item) {
            return item.id == product.id ? product : item;
          }).toList()
        : [...current.products, product];

    _setStoreState(
      current.copyWith(products: products, selectedProductId: product.id),
    );
  }

  void _updateBagItems(StoreState current, List<BagItem> bagItems) {
    _setStoreState(current.copyWith(bagItems: bagItems));
    unawaited(ref.read(saveBagItemsProvider)(bagItems));
  }

  void _updatePaymentMethods(
    StoreState current,
    List<PaymentMethod> paymentMethods, {
    required String selectedPaymentMethodId,
  }) {
    _setStoreState(
      current.copyWith(
        paymentMethods: paymentMethods,
        selectedPaymentMethodId: selectedPaymentMethodId,
      ),
    );
    unawaited(ref.read(savePaymentMethodsProvider)(paymentMethods));
  }

  void _setStoreState(StoreState value) {
    state = AsyncData(value);
  }

  Product _productById(StoreState current, String id) {
    if (current.products.isEmpty) {
      throw StateError('No products are available.');
    }

    return current.products.firstWhere(
      (product) => product.id == id,
      orElse: () => current.products.first,
    );
  }

  Product _productForBag(Product product) {
    return product.copyWith(
      id: _bagProductId(product),
      variant: '${_colorName(product.selectedColor)} / ${product.selectedSize}',
    );
  }

  String _bagProductId(Product product) {
    final color = product.selectedColor
        .toUnsigned(32)
        .toRadixString(16)
        .padLeft(8, '0');

    return '${product.id}-${product.selectedSize}-$color';
  }

  String _colorName(int color) {
    return switch (color) {
      0xFF0A7CFF => 'Blue',
      0xFF202129 => 'Black',
      0xFF777981 => 'Gray',
      0xFFB8BAC0 => 'Silver',
      0xFFE4E6EF => 'White',
      0xFFD8B76A => 'Gold',
      0xFF56A06D => 'Green',
      _ => '#${color.toUnsigned(32).toRadixString(16).padLeft(8, '0')}',
    };
  }

  String _cardBrand(String digits) {
    if (digits.startsWith('4')) {
      return 'Visa';
    }

    if (digits.startsWith('5')) {
      return 'Mastercard';
    }

    if (digits.startsWith('3')) {
      return 'Amex';
    }

    return 'Credit Card';
  }
}
