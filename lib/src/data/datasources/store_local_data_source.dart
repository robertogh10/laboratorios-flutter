import 'dart:convert';

import 'package:laboratorio_experinece_app/src/core/local_storage.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/payment_method_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreLocalDataSource implements StoreDataSource {
  StoreLocalDataSource({SharedPreferences? sharedPreferences})
    : _prefs = sharedPreferences ?? LocalStorage().prefs;

  static const _bagItemsKey = 'bagItems';
  static const _paymentMethodsKey = 'paymentMethods';

  final SharedPreferences _prefs;

  @override
  Future<List<ProductModel>> getProducts() async {
    return const [
      ProductModel(
        id: 'amazing-shirt',
        name: 'Amazing T-shirt',
        variant: 'Black / M',
        category: 'perfect',
        price: 20,
        description:
            'The perfect T-shirt for when you want to feel comfortable but still stylish. Amazing for all occasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look to the outfit. Perfect for the warmest days.',
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        selectedSize: 'S',
        colors: [0xFF202129, 0xFF777981, 0xFFB8BAC0, 0xFFE4E6EF],
        selectedColor: 0xFFB8BAC0,
      ),
      ProductModel(
        id: 'fabulous-pants',
        name: 'Fabulous Pants',
        variant: 'Blue / 40',
        category: 'perfect',
        price: 10,
        description:
            'Soft everyday pants with a relaxed cut and clean finish for casual days.',
        sizes: ['37', '38', '39', '40'],
        selectedSize: '40',
        colors: [0xFF0A7CFF, 0xFF777981, 0xFFE4E6EF],
        selectedColor: 0xFF0A7CFF,
      ),
      ProductModel(
        id: 'spectacular-dress',
        name: 'Spectacular Dress',
        variant: 'Gold / L',
        category: 'summer',
        price: 16,
        description:
            'Light dress with a polished silhouette for summer evenings and special days.',
        sizes: ['S', 'M', 'L'],
        selectedSize: 'L',
        colors: [0xFFD8B76A, 0xFF202129, 0xFFE4E6EF],
        selectedColor: 0xFFD8B76A,
      ),
      ProductModel(
        id: 'stunning-jacket',
        name: 'Stunning Jacket',
        variant: 'Blue / M',
        category: 'summer',
        price: 12,
        description:
            'Modern lightweight jacket with a clean fit and soft blue finish.',
        sizes: ['S', 'M', 'L', 'XL'],
        selectedSize: 'M',
        colors: [0xFF0A7CFF, 0xFF202129, 0xFFE4E6EF],
        selectedColor: 0xFF0A7CFF,
      ),
      ProductModel(
        id: 'wonderful-shoes',
        name: 'Wonderful Shoes',
        variant: 'Green / 39',
        category: 'summer',
        price: 25,
        description:
            'Comfortable shoes with a fresh green accent for daily walks.',
        sizes: ['37', '38', '39', '40'],
        selectedSize: '39',
        colors: [0xFF56A06D, 0xFF202129, 0xFFE4E6EF],
        selectedColor: 0xFF56A06D,
      ),
    ];
  }

  @override
  Future<List<BagItemModel>> getBagItems() async {
    return _readSavedBagItems() ?? await _defaultBagItems();
  }

  @override
  Future<void> saveBagItems(List<BagItemModel> items) async {
    await _prefs.setString(
      _bagItemsKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return _readSavedPaymentMethods() ?? _defaultPaymentMethods();
  }

  @override
  Future<void> savePaymentMethods(List<PaymentMethodModel> methods) async {
    await _prefs.setString(
      _paymentMethodsKey,
      jsonEncode(methods.map((method) => method.toJson()).toList()),
    );
  }

  List<PaymentMethodModel> _defaultPaymentMethods() {
    return const [
      PaymentMethodModel(
        id: 'mastercard',
        title: 'Mastercard',
        subtitle: 'xxxx xxxx xxxx 1234',
        enabled: true,
      ),
      PaymentMethodModel(
        id: 'visa',
        title: 'Visa',
        subtitle: 'xxxx xxxx xxxx 9876',
        enabled: true,
      ),
      PaymentMethodModel(
        id: 'apple-pay',
        title: 'Apple Pay',
        subtitle: '',
        enabled: false,
      ),
    ];
  }

  Future<List<BagItemModel>> _defaultBagItems() async {
    final products = (await getProducts()).map(_productForBag).toList();

    return [
      BagItemModel(product: products[0], quantity: 1),
      BagItemModel(product: products[1], quantity: 1),
      BagItemModel(product: products[2], quantity: 1),
      BagItemModel(product: products[3], quantity: 1),
      BagItemModel(product: products[4], quantity: 1),
    ];
  }

  List<BagItemModel>? _readSavedBagItems() {
    try {
      final items = _readList(_bagItemsKey);
      if (items is! List) {
        return null;
      }

      return items
          .whereType<Map<String, Object?>>()
          .map(BagItemModel.fromJson)
          .toList();
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  List<PaymentMethodModel>? _readSavedPaymentMethods() {
    try {
      final methods = _readList(_paymentMethodsKey);
      if (methods is! List) {
        return null;
      }

      return methods
          .whereType<Map<String, Object?>>()
          .map(PaymentMethodModel.fromJson)
          .toList();
    } on TypeError {
      return null;
    }
  }

  Object? _readList(String key) {
    final savedValue = _prefs.getString(key);
    if (savedValue == null || savedValue.isEmpty) {
      return null;
    }

    return jsonDecode(savedValue);
  }

  ProductModel _productForBag(ProductModel product) {
    return product.copyWith(
      id: _bagProductId(product),
      variant: '${_colorName(product.selectedColor)} / ${product.selectedSize}',
    );
  }

  String _bagProductId(ProductModel product) {
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
}
