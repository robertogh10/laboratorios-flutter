import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class GetProducts {
  const GetProducts(this._repository);

  final StoreRepository _repository;

  List<Product> call() {
    return _repository.getProducts();
  }
}
