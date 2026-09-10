import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../pages/auth_page.dart';

GoRouter createFirebaseLoginRouter({
  required String initialLocation,
  required String signedInHomePath,
  required List<String> protectedPathPrefixes,
  required List<RouteBase> routes,
  bool firebaseEnabled = false,
  String loginPath = '/auth/login',
  String registerPath = '/auth/register',
  String? demoPath,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: firebaseEnabled
        ? GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges())
        : null,
    redirect: (context, state) {
      final path = state.uri.path;
      final isAuthRoute = path == loginPath || path == registerPath;
      final isProtectedRoute = protectedPathPrefixes.any(path.startsWith);
      final isSignedIn =
          firebaseEnabled && FirebaseAuth.instance.currentUser != null;

      if (firebaseEnabled && isProtectedRoute && !isSignedIn) {
        return loginPath;
      }

      if (isAuthRoute && isSignedIn) {
        return signedInHomePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) {
          return AuthPage(
            mode: AuthPageMode.login,
            successRoute: signedInHomePath,
            loginRoute: loginPath,
            registerRoute: registerPath,
            demoRoute: demoPath,
          );
        },
      ),
      GoRoute(
        path: registerPath,
        builder: (context, state) {
          return AuthPage(
            mode: AuthPageMode.register,
            successRoute: signedInHomePath,
            loginRoute: loginPath,
            registerRoute: registerPath,
            demoRoute: demoPath,
          );
        },
      ),
      ...routes,
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
