import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/payment_method_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('persists bag items in local storage', () async {
    final prefs = await _emptyPrefs();
    final dataSource = StoreLocalDataSource(sharedPreferences: prefs);
    final savedItems = [
      (await dataSource.getBagItems()).first.copyWith(quantity: 4),
    ];

    await dataSource.saveBagItems(savedItems);

    final reloadedDataSource = StoreLocalDataSource(sharedPreferences: prefs);
    final reloadedItems = await reloadedDataSource.getBagItems();

    expect(reloadedItems, hasLength(1));
    expect(reloadedItems.first.quantity, 4);
    expect(reloadedItems.first.product.id, savedItems.first.product.id);
  });

  test('persists payment methods without replacing bag items', () async {
    final prefs = await _emptyPrefs();
    final dataSource = StoreLocalDataSource(sharedPreferences: prefs);
    final savedItems = [
      (await dataSource.getBagItems()).first.copyWith(quantity: 3),
    ];
    final savedMethods = [
      ...(await dataSource.getPaymentMethods()),
      const PaymentMethodModel(
        id: 'card-test',
        title: 'Amex',
        subtitle: 'xxxx xxxx xxxx 0005 - Roberto Giron - 12/29',
        enabled: true,
      ),
    ];

    await dataSource.saveBagItems(savedItems);
    await dataSource.savePaymentMethods(savedMethods);

    final reloadedDataSource = StoreLocalDataSource(sharedPreferences: prefs);

    expect((await reloadedDataSource.getBagItems()).first.quantity, 3);
    expect(
      (await reloadedDataSource.getPaymentMethods()).map((method) => method.id),
      contains('card-test'),
    );
  });
}

Future<SharedPreferences> _emptyPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
