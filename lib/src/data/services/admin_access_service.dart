import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAccessService {
  const AdminAccessService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<bool> isAdmin({required String uid, required String email}) async {
    final normalizedEmail = email.trim().toLowerCase();
    final collection = _firestore.collection('admins');

    if (uid.isNotEmpty) {
      final uidDocument = await collection.doc(uid).get();

      if (uidDocument.exists) {
        return true;
      }
    }

    if (normalizedEmail.isEmpty) {
      return false;
    }

    // Email document IDs remain supported for projects that already use the
    // original setup, but UID document IDs are preferred.
    return (await collection.doc(normalizedEmail).get()).exists;
  }
}
