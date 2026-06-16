import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/payment_method_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';

abstract interface class StoreDataSource {
  Future<List<ProductModel>> getProducts();

  Future<List<BagItemModel>> getBagItems();

  Future<List<PaymentMethodModel>> getPaymentMethods();

  Future<void> saveBagItems(List<BagItemModel> items);

  Future<void> savePaymentMethods(List<PaymentMethodModel> methods);
}
