import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/sales_repository.dart';

class WatchSales {
  const WatchSales(this._repository);

  final SalesRepository _repository;

  Stream<List<Sale>> call({required String userId, required bool isAdmin}) {
    return _repository.watchSales(userId: userId, isAdmin: isAdmin);
  }
}
