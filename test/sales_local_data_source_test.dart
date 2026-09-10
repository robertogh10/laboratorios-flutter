import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/sales_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/sale_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('emits a newly created sale through the customer stream', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dataSource = SalesLocalDataSource(sharedPreferences: prefs);
    final emissions = <List<SaleModel>>[];
    final subscription = dataSource
        .watchSales(userId: 'user-1', isAdmin: false)
        .listen(emissions.add);
    addTearDown(subscription.cancel);

    await Future<void>.delayed(Duration.zero);
    await dataSource.createSale(_sale(userId: 'user-1', total: 42));
    await Future<void>.delayed(Duration.zero);

    expect(emissions, hasLength(2));
    expect(emissions.first, isEmpty);
    expect(emissions.last.single.total, 42);
    expect(emissions.last.single.id, startsWith('sale-'));
  });

  test('customer stream filters sales while admin stream sees all', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dataSource = SalesLocalDataSource(sharedPreferences: prefs);

    await dataSource.createSale(_sale(userId: 'user-1', total: 10));
    await dataSource.createSale(_sale(userId: 'user-2', total: 20));

    final customerSales = await dataSource
        .watchSales(userId: 'user-1', isAdmin: false)
        .first;
    final adminSales = await dataSource
        .watchSales(userId: 'admin', isAdmin: true)
        .first;

    expect(customerSales, hasLength(1));
    expect(customerSales.single.userId, 'user-1');
    expect(adminSales, hasLength(2));
  });
}

SaleModel _sale({required String userId, required double total}) {
  const product = ProductModel(
    id: 'shirt',
    name: 'Shirt',
    variant: 'Black / M',
    category: 'perfect',
    price: 10,
    description: 'Test product',
    sizes: ['M'],
    selectedSize: 'M',
    colors: [0xFF202129],
    selectedColor: 0xFF202129,
  );

  return SaleModel(
    id: '',
    userId: userId,
    userEmail: '$userId@example.com',
    items: const [BagItemModel(product: product, quantity: 1)],
    total: total,
    paymentMethod: 'Visa',
    status: 'created',
    createdAt: DateTime.utc(2026, 7, 23),
  );
}
