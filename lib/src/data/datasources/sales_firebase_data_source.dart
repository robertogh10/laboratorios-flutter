import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/sales_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/sale_model.dart';

class SalesFirebaseDataSource implements SalesDataSource {
  SalesFirebaseDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _salesCollection {
    return _firestore.collection('sales');
  }

  @override
  Future<SaleModel> createSale(SaleModel sale) async {
    final document = await _salesCollection.add(
      sale.toJson().map((key, value) => MapEntry(key, value)),
    );

    return SaleModel(
      id: document.id,
      userId: sale.userId,
      userEmail: sale.userEmail,
      items: sale.items,
      total: sale.total,
      paymentMethod: sale.paymentMethod,
      status: sale.status,
      createdAt: sale.createdAt,
    );
  }

  @override
  Stream<List<SaleModel>> watchSales({
    required String userId,
    required bool isAdmin,
  }) {
    final Query<Map<String, dynamic>> query = isAdmin
        ? _salesCollection
        : _salesCollection.where('userId', isEqualTo: userId);

    return query.snapshots().map((snapshot) {
      final sales = snapshot.docs.map((document) {
        return SaleModel.fromJson(
          id: document.id,
          json: Map<String, Object?>.from(document.data()),
        );
      }).toList();

      sales.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return sales;
    });
  }
}
