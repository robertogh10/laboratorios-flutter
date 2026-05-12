import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/onboarding_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/repositories/onboarding_repository_impl.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/onboarding_repository.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/get_interests.dart';
import 'package:laboratorio_experinece_app/src/ui/state/onboarding_state.dart';

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  return const OnboardingLocalDataSource();
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(ref.watch(onboardingLocalDataSourceProvider));
});

final getInterestsProvider = Provider<GetInterests>((ref) {
  return GetInterests(ref.watch(onboardingRepositoryProvider));
});

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
      OnboardingController.new,
    );

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return OnboardingState(
      pageIndex: 0,
      interests: ref.watch(getInterestsProvider)(),
    );
  }

  void next() {
    final nextIndex = state.pageIndex < 2 ? state.pageIndex + 1 : 2;
    state = state.copyWith(pageIndex: nextIndex);
  }

  void toggleInterest(String id) {
    final interests = state.interests.map((interest) {
      if (interest.id != id) {
        return interest;
      }

      return interest.copyWith(selected: !interest.selected);
    }).toList();

    state = state.copyWith(interests: interests);
  }
}
