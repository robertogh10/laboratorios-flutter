import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/onboarding_page.dart';
import 'package:laboratorio_experinece_app/src/ui/pages/store_flow_page.dart';

abstract final class AppRoutes {
  static const onboardingIntro = '/onboarding/intro';
  static const onboardingInterests = '/onboarding/interests';
  static const storeHome = '/store';
  static const storeBag = '/store/bag';
  static const storeCheckout = '/store/checkout';

  static String storeProduct(String productId) {
    return '/store/product/$productId';
  }
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.onboardingIntro,
    redirect: (context, state) {
      if (state.uri.path == '/') {
        return AppRoutes.onboardingIntro;
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
        path: AppRoutes.storeHome,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.home);
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
        path: AppRoutes.storeCheckout,
        builder: (context, state) {
          return const StoreFlowPage(view: StoreRouteView.checkout);
        },
      ),
    ],
  );
}
