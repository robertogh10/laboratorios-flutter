import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/services/admin_access_service.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/auth_session.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final adminAccessServiceProvider = Provider<AdminAccessService>((ref) {
  return AdminAccessService(ref.watch(firestoreProvider));
});

final authSessionProvider = StreamProvider<AuthSession?>((ref) {
  if (!ref.watch(firebaseEnabledProvider)) {
    return Stream<AuthSession?>.value(null);
  }

  return ref.watch(firebaseAuthProvider).authStateChanges().asyncMap((
    user,
  ) async {
    if (user == null) {
      return null;
    }

    final email = user.email ?? '';
    final isAdmin = await ref
        .read(adminAccessServiceProvider)
        .isAdmin(uid: user.uid, email: email);

    return AuthSession(uid: user.uid, email: email, isAdmin: isAdmin);
  });
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn({required String email, required String password}) async {
    await _runAuthAction(() {
      return ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(
            email: email.trim().toLowerCase(),
            password: password,
          );
    });
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(() {
      return ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(
            email: email.trim().toLowerCase(),
            password: password,
          );
    });
  }

  Future<bool> sendPasswordReset(String email) async {
    if (!ref.read(firebaseEnabledProvider)) {
      state = AsyncError(
        StateError('Firebase no esta configurado para esta ejecucion.'),
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    try {
      await ref
          .read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: email.trim().toLowerCase());
      state = const AsyncData(null);
      return true;
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncError(_friendlyMessage(error), stackTrace);
      return false;
    }
  }

  Future<void> signOut() async {
    if (!ref.read(firebaseEnabledProvider)) {
      return;
    }

    await ref.read(firebaseAuthProvider).signOut();
    ref.invalidate(storeControllerProvider);
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    if (!ref.read(firebaseEnabledProvider)) {
      state = AsyncError(
        StateError('Firebase no esta configurado para esta ejecucion.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    try {
      await action();
      state = const AsyncData(null);
      ref.invalidate(storeControllerProvider);
    } on FirebaseAuthException catch (error, stackTrace) {
      state = AsyncError(_friendlyMessage(error), stackTrace);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  String _friendlyMessage(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-email' => 'El correo no tiene un formato valido.',
      'user-disabled' => 'Esta cuenta esta deshabilitada.',
      'user-not-found' => 'No existe una cuenta con ese correo.',
      'wrong-password' => 'La contrasena no es correcta.',
      'invalid-credential' => 'El correo o la contrasena no son correctos.',
      'email-already-in-use' => 'Ya existe una cuenta con ese correo.',
      'weak-password' => 'Usa una contrasena de al menos 6 caracteres.',
      'network-request-failed' => 'No se pudo conectar con Firebase.',
      _ => error.message ?? 'No se pudo completar la autenticacion.',
    };
  }
}
