import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/services/profile_service.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/user_profile.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, UserProfile>(
      ProfileController.new,
    );

class ProfileController extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    if (!ref.watch(firebaseEnabledProvider)) {
      return const UserProfile(
        uid: 'demo-user',
        email: 'demo@local',
        displayName: 'Usuario demo',
      );
    }

    return ref.watch(profileServiceProvider).load();
  }

  Future<void> updatePhoto() async {
    if (!ref.read(firebaseEnabledProvider)) {
      return;
    }

    final previous = state.asData?.value;
    state = const AsyncLoading();

    try {
      final updated = await ref
          .read(profileServiceProvider)
          .pickAndUploadImage();
      state = AsyncData(updated ?? previous ?? await _reload());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<UserProfile> _reload() {
    return ref.read(profileServiceProvider).load();
  }
}
