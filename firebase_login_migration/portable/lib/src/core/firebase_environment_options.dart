import 'package:firebase_core/firebase_core.dart';

class FirebaseEnvironmentOptions {
  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const _databaseURL = String.fromEnvironment('FIREBASE_DATABASE_URL');
  static const _storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );
  static const _measurementId = String.fromEnvironment(
    'FIREBASE_MEASUREMENT_ID',
  );
  static const _androidClientId = String.fromEnvironment(
    'FIREBASE_ANDROID_CLIENT_ID',
  );
  static const _iosClientId = String.fromEnvironment('FIREBASE_IOS_CLIENT_ID');
  static const _iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');

  static bool get isConfigured {
    return _apiKey.isNotEmpty &&
        _appId.isNotEmpty &&
        _messagingSenderId.isNotEmpty &&
        _projectId.isNotEmpty;
  }

  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      authDomain: _nullable(_authDomain),
      databaseURL: _nullable(_databaseURL),
      storageBucket: _nullable(_storageBucket),
      measurementId: _nullable(_measurementId),
      androidClientId: _nullable(_androidClientId),
      iosClientId: _nullable(_iosClientId),
      iosBundleId: _nullable(_iosBundleId),
    );
  }

  static String? _nullable(String value) {
    return value.isEmpty ? null : value;
  }
}
