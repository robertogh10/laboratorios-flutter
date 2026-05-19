import 'package:laboratorio_experinece_app/src/data/datasources/store_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  const StoreRepositoryImpl(this._dataSource);

  final StoreLocalDataSource _dataSource;

  @override
  List<BagItem> getBagItems() {
    return _dataSource.getBagItems().map((item) => item.toEntity()).toList();
  }

  @override
  List<PaymentMethod> getPaymentMethods() {
    return _dataSource
        .getPaymentMethods()
        .map((method) => method.toEntity())
        .toList();
  }

  @override
  List<Product> getProducts() {
    return _dataSource
        .getProducts()
        .map((product) => product.toEntity())
        .toList();
  }
}
