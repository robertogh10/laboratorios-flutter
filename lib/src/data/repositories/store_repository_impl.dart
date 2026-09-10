import 'package:laboratorio_experinece_app/src/data/datasources/store_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/payment_method_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  const StoreRepositoryImpl(this._dataSource);

  final StoreDataSource _dataSource;

  @override
  Future<List<BagItem>> getBagItems() async {
    final items = await _dataSource.getBagItems();

    return items.map((item) => item.toEntity()).toList();
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    final methods = await _dataSource.getPaymentMethods();

    return methods.map((method) => method.toEntity()).toList();
  }

  @override
  Future<List<Product>> getProducts() async {
    final products = await _dataSource.getProducts();

    return products.map((product) => product.toEntity()).toList();
  }

  @override
  Future<void> saveProduct(Product product) {
    return _dataSource.saveProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> saveBagItems(List<BagItem> items) {
    return _dataSource.saveBagItems(
      items.map((item) => BagItemModel.fromEntity(item)).toList(),
    );
  }

  @override
  Future<void> savePaymentMethods(List<PaymentMethod> methods) {
    return _dataSource.savePaymentMethods(
      methods.map((method) => PaymentMethodModel.fromEntity(method)).toList(),
    );
  }
}
