import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAccessService {
  const AdminAccessService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<bool> isAdminEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty) {
      return false;
    }

    final collection = _firestore.collection('admins');
    final doc = await collection.doc(normalizedEmail).get();

    if (doc.exists) {
      return true;
    }

    final normalizedQuery = await collection
        .where('email', isEqualTo: normalizedEmail)
        .limit(1)
        .get();

    if (normalizedQuery.docs.isNotEmpty) {
      return true;
    }

    if (email.trim() == normalizedEmail) {
      return false;
    }

    final originalQuery = await collection
        .where('email', isEqualTo: email.trim())
        .limit(1)
        .get();

    return originalQuery.docs.isNotEmpty;
  }
}
