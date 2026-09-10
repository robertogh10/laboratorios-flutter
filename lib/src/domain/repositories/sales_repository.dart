import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';

abstract interface class SalesRepository {
  Future<Sale> createSale(Sale sale);

  Stream<List<Sale>> watchSales({
    required String userId,
    required bool isAdmin,
  });
}
