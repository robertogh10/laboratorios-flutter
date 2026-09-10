import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/sales_repository.dart';

class CreateSale {
  const CreateSale(this._repository);

  final SalesRepository _repository;

  Future<Sale> call(Sale sale) {
    return _repository.createSale(sale);
  }
}
