import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/onboarding_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/intro_step_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/interests_step_view.dart';

enum OnboardingStep { intro, interests }

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: switch (step) {
        OnboardingStep.intro => IntroStepView(
          onNext: () => context.go(AppRoutes.onboardingInterests),
        ),
        OnboardingStep.interests => InterestsStepView(
          interests: state.interests,
          onInterestPressed: controller.toggleInterest,
          onNext: () => context.go(AppRoutes.storeHome),
        ),
      },
    );
  }
}
