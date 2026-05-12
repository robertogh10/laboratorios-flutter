import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/onboarding_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/intro_step_view.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/interests_step_view.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: IndexedStack(
        index: state.pageIndex,
        children: [
          IntroStepView(onNext: controller.next),
          InterestsStepView(
            interests: state.interests,
            onInterestPressed: controller.toggleInterest,
            onNext: controller.next,
          ),
          const SizedBox.expand(),
        ],
      ),
    );
  }
}
