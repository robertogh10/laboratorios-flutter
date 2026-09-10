import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/user_profile.dart';

class ProfileService {
  ProfileService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _imagePicker = imagePicker ?? ImagePicker();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;

  Future<UserProfile> load() async {
    final user = _requireUser();
    final document = await _firestore.collection('users').doc(user.uid).get();
    final data = document.data();
    final email = (data?['email'] as String?) ?? user.email ?? '';
    final displayName = (data?['displayName'] as String?)?.trim();
    final photoUrl = (data?['profileImageUrl'] as String?) ?? user.photoURL;

    return UserProfile(
      uid: user.uid,
      email: email,
      displayName: displayName?.isNotEmpty == true
          ? displayName!
          : _nameFromEmail(email),
      photoUrl: photoUrl,
    );
  }

  Future<UserProfile?> pickAndUploadImage() async {
    final user = _requireUser();
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (image == null) {
      return null;
    }

    final bytes = await image.readAsBytes();
    final reference = _storage.ref().child('profile_images/${user.uid}/avatar');
    await reference.putData(
      bytes,
      SettableMetadata(contentType: _contentType(image.name)),
    );
    final photoUrl = await reference.getDownloadURL();

    await Future.wait([
      user.updatePhotoURL(photoUrl),
      _firestore.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'displayName': user.displayName ?? _nameFromEmail(user.email ?? ''),
        'profileImageUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
    ]);

    return load();
  }

  User _requireUser() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('Inicia sesion para consultar tu perfil.');
    }

    return user;
  }

  String _nameFromEmail(String email) {
    final localPart = email.split('@').first.trim();

    if (localPart.isEmpty) {
      return 'Usuario';
    }

    return localPart
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String _contentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    return switch (extension) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      _ => 'image/jpeg',
    };
  }
}
