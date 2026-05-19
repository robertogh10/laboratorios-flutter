import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/payment_method_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';

class StoreLocalDataSource {
  const StoreLocalDataSource();

  List<ProductModel> getProducts() {
    return const [
      ProductModel(
        id: 'amazing-shirt',
        name: 'Amazing T-shirt',
        variant: 'Black / M',
        category: 'perfect',
        price: 12,
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
        variant: 'Blue / 42',
        category: 'perfect',
        price: 15,
        description:
            'Soft everyday pants with a relaxed cut and clean finish for casual days.',
        sizes: ['38', '40', '42', '44'],
        selectedSize: '42',
        colors: [0xFF0A7CFF, 0xFF777981, 0xFFE4E6EF],
        selectedColor: 0xFF0A7CFF,
      ),
      ProductModel(
        id: 'spectacular-dress',
        name: 'Spectacular Dress',
        variant: 'Gold / L',
        category: 'summer',
        price: 20,
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
        price: 18,
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
        price: 18,
        description:
            'Comfortable shoes with a fresh green accent for daily walks.',
        sizes: ['38', '39', '40', '41'],
        selectedSize: '39',
        colors: [0xFF56A06D, 0xFF202129, 0xFFE4E6EF],
        selectedColor: 0xFF56A06D,
      ),
    ];
  }

  List<BagItemModel> getBagItems() {
    final products = getProducts();

    return [
      BagItemModel(product: products[0], quantity: 1),
      BagItemModel(product: products[1], quantity: 1),
      BagItemModel(product: products[2], quantity: 1),
      BagItemModel(product: products[3], quantity: 1),
      BagItemModel(product: products[4], quantity: 1),
    ];
  }

  List<PaymentMethodModel> getPaymentMethods() {
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
}
