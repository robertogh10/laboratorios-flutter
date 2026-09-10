import 'package:laboratorio_experinece_app/src/data/datasources/sales_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/sale_model.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/sales_repository.dart';

class SalesRepositoryImpl implements SalesRepository {
  const SalesRepositoryImpl(this._dataSource);

  final SalesDataSource _dataSource;

  @override
  Future<Sale> createSale(Sale sale) async {
    return (await _dataSource.createSale(
      SaleModel.fromEntity(sale),
    )).toEntity();
  }

  @override
  Stream<List<Sale>> watchSales({
    required String userId,
    required bool isAdmin,
  }) {
    return _dataSource
        .watchSales(userId: userId, isAdmin: isAdmin)
        .map((sales) => sales.map((sale) => sale.toEntity()).toList());
  }
}
