import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_step.freezed.dart';

@freezed
abstract class OnboardingStepEntity with _$OnboardingStepEntity {
  const factory OnboardingStepEntity({
    required int index,
    required String title,
    required String subtitle,
    required double progress,
  }) = _OnboardingStepEntity;
}
