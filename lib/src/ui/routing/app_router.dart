import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/auth_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/credit_request_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/onboarding_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/product_form_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/profile_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/sale_detail_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/store_flow_page.dart';

abstract final class AppRoutes {
  static const onboardingIntro = '/onboarding/intro';
  static const onboardingInterests = '/onboarding/interests';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const storeHome = '/store';
  static const storeBag = '/store/bag';
  static const storeSales = '/store/sales';
  static const storeCheckout = '/store/checkout';
  static const storeAddCard = '/store/checkout/add-card';
  static const storeProfile = '/store/profile';
  static const storeCredit = '/store/profile/credit';
  static const storeNewProduct = '/store/admin/products/new';

  static String storeProduct(String productId) {
    return '/store/product/$productId';
  }

  static String storeSale(String saleId) {
    return '/store/sales/${Uri.encodeComponent(saleId)}';
  }

  static String storeEditProduct(String productId) {
    return '/store/admin/products/$productId/edit';
  }
}

GoRouter createAppRouter({bool firebaseEnabled = false}) {
  return GoRouter(
    initialLocation: AppRoutes.onboardingIntro,
    refreshListenable: firebaseEnabled
        ? GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges())
        : null,
    redirect: (context, state) {
      final path = state.uri.path;

      if (path == '/') {
        return AppRoutes.onboardingIntro;
      }

      final isAuthRoute = path == AppRoutes.login || path == AppRoutes.register;
      final isOnboardingRoute = path.startsWith('/onboarding');
      final isStoreRoute = path.startsWith('/store');
      final isSignedIn =
          firebaseEnabled && FirebaseAuth.instance.currentUser != null;

      if (firebaseEnabled && isStoreRoute && !isSignedIn) {
        return '${AppRoutes.login}?from=${Uri.encodeComponent(state.uri.toString())}';
      }

      if (isAuthRoute && isSignedIn) {
        final destination = state.uri.queryParameters['from'];
        return destination != null && destination.startsWith('/store/')
            ? destination
            : AppRoutes.storeHome;
      }

      if (isOnboardingRoute && isSignedIn) {
        return AppRoutes.storeHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboardingIntro,
        builder: (context, state) {
          return const OnboardingPage(step: OnboardingStep.intro);
        },
      ),
      GoRoute(
        path: AppRoutes.onboardingInterests,
        builder: (context, state) {
          return const OnboardingPage(step: OnboardingStep.interests);
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return const AuthPage(mode: AuthPageMode.login);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          return const AuthPage(mode: AuthPageMode.register);
        },
      ),
      GoRoute(
        path: AppRoutes.storeHome,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.home);
        },
      ),
      GoRoute(
        path: AppRoutes.storeNewProduct,
        builder: (context, state) {
          return const ProductFormPage();
        },
      ),
      GoRoute(
        path: '/store/admin/products/:productId/edit',
        builder: (context, state) {
          return ProductFormPage(productId: state.pathParameters['productId']);
        },
      ),
      GoRoute(
        path: '/store/product/:productId',
        builder: (context, state) {
          return StoreFlowPage(
            view: StoreRouteView.detail,
            productId: state.pathParameters['productId'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.storeBag,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.bag);
        },
      ),
      GoRoute(
        path: AppRoutes.storeSales,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.sales);
        },
      ),
      GoRoute(
        path: '/store/sales/:saleId',
        builder: (context, state) =>
            SaleDetailPage(saleId: state.pathParameters['saleId']!),
      ),
      GoRoute(
        path: AppRoutes.storeCheckout,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.checkout);
        },
      ),
      GoRoute(
        path: AppRoutes.storeAddCard,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.addCard);
        },
      ),
      GoRoute(
        path: AppRoutes.storeProfile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.storeCredit,
        builder: (context, state) => const CreditRequestPage(),
      ),
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
