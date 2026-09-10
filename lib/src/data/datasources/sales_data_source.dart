import 'package:laboratorio_experinece_app/src/data/models/sale_model.dart';

abstract interface class SalesDataSource {
  Future<SaleModel> createSale(SaleModel sale);

  Stream<List<SaleModel>> watchSales({
    required String userId,
    required bool isAdmin,
  });
}
