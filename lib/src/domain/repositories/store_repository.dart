import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';

abstract interface class StoreRepository {
  Future<List<Product>> getProducts();

  Future<List<BagItem>> getBagItems();

  Future<List<PaymentMethod>> getPaymentMethods();

  Future<void> saveBagItems(List<BagItem> items);

  Future<void> savePaymentMethods(List<PaymentMethod> methods);
}
