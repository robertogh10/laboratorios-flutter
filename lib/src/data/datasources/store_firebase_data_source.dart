import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/store_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/payment_method_model.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';

class StoreFirebaseDataSource implements StoreDataSource {
  StoreFirebaseDataSource({
    FirebaseFirestore? firestore,
    StoreLocalDataSource? fallbackDataSource,
    this.userId = 'demo-user',
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _fallbackDataSource = fallbackDataSource ?? StoreLocalDataSource();

  final FirebaseFirestore _firestore;
  final StoreLocalDataSource _fallbackDataSource;
  final String userId;

  CollectionReference<Map<String, dynamic>> get _productsCollection {
    return _firestore.collection('products');
  }

  CollectionReference<Map<String, dynamic>> get _bagItemsCollection {
    return _firestore.collection('users').doc(userId).collection('bagItems');
  }

  CollectionReference<Map<String, dynamic>> get _paymentMethodsCollection {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('paymentMethods');
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _productsCollection.get();

    if (snapshot.docs.isEmpty) {
      return _fallbackDataSource.getProducts();
    }

    return snapshot.docs.map((doc) {
      final data = Map<String, Object?>.from(doc.data());

      return ProductModel.fromJson({'id': doc.id, ...data});
    }).toList();
  }

  @override
  Future<List<BagItemModel>> getBagItems() async {
    final snapshot = await _bagItemsCollection.get();

    if (snapshot.docs.isEmpty) {
      if (userId == 'demo-user') {
        return _fallbackDataSource.getBagItems();
      }

      return [];
    }

    return snapshot.docs.map((doc) {
      return BagItemModel.fromJson(Map<String, Object?>.from(doc.data()));
    }).toList();
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final snapshot = await _paymentMethodsCollection.get();

    if (snapshot.docs.isEmpty) {
      return _fallbackDataSource.getPaymentMethods();
    }

    return snapshot.docs.map((doc) {
      final data = Map<String, Object?>.from(doc.data());

      return PaymentMethodModel.fromJson({'id': doc.id, ...data});
    }).toList();
  }

  @override
  Future<void> saveBagItems(List<BagItemModel> items) {
    return _replaceCollection(
      _bagItemsCollection,
      items.map((item) => MapEntry(item.product.id, item.toJson())),
    );
  }

  @override
  Future<void> savePaymentMethods(List<PaymentMethodModel> methods) {
    return _replaceCollection(
      _paymentMethodsCollection,
      methods.map((method) => MapEntry(method.id, method.toJson())),
    );
  }

  Future<void> _replaceCollection(
    CollectionReference<Map<String, dynamic>> collection,
    Iterable<MapEntry<String, Map<String, Object?>>> documents,
  ) async {
    final existing = await collection.get();
    final batch = _firestore.batch();

    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

    for (final document in documents) {
      batch.set(collection.doc(document.key), _firestoreData(document.value));
    }

    await batch.commit();
  }

  Map<String, dynamic> _firestoreData(Map<String, Object?> json) {
    return json.map((key, value) => MapEntry(key, value));
  }
}
