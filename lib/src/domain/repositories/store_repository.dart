import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';

abstract interface class StoreRepository {
  List<Product> getProducts();

  List<BagItem> getBagItems();

  List<PaymentMethod> getPaymentMethods();
}
