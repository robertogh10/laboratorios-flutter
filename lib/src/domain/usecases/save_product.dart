import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class SaveProduct {
  const SaveProduct(this._repository);

  final StoreRepository _repository;

  Future<void> call(Product product) {
    return _repository.saveProduct(product);
  }
}
