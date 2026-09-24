import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:laboratorio_experinece_app/src/core/firebase_environment_options.dart';

class FirebaseBootstrap {
  static const useEmulators = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
  static const _configuredHost = String.fromEnvironment(
    'FIREBASE_EMULATOR_HOST',
  );

  static Future<bool> initializeIfConfigured() async {
    if (Firebase.apps.isNotEmpty) {
      await _connectEmulators();
      return true;
    }

    if (!FirebaseEnvironmentOptions.isConfigured) {
      if (_canUseNativeConfiguration) {
        final initialized = await _initializeFromNativeConfiguration();
        if (!initialized && useEmulators) {
          throw StateError(
            'No se pudo inicializar Firebase con la configuración nativa de esta plataforma.',
          );
        }
        if (initialized) await _connectEmulators();
        return initialized;
      }

      if (useEmulators) {
        throw StateError(
          'Configura Firebase para esta plataforma antes de usar los emuladores.',
        );
      }
      return false;
    }

    await Firebase.initializeApp(
      options: FirebaseEnvironmentOptions.currentPlatform,
    );

    await _connectEmulators();

    return true;
  }

  static Future<void> _connectEmulators() async {
    if (!useEmulators) return;
    if (kReleaseMode) {
      throw StateError('Los emuladores solo están disponibles en desarrollo.');
    }

    final host = _configuredHost.isNotEmpty
        ? _configuredHost
        : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : '127.0.0.1';

    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
  }

  static bool get _canUseNativeConfiguration {
    return !kIsWeb &&
        {
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        }.contains(defaultTargetPlatform);
  }

  static Future<bool> _initializeFromNativeConfiguration() async {
    try {
      await Firebase.initializeApp();

      return true;
    } on FirebaseException {
      return false;
    }
  }
}
