import 'package:laboratorio_experinece_app/src/domain/entities/interest.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/onboarding_repository.dart';

class GetInterests {
  const GetInterests(this._repository);

  final OnboardingRepository _repository;

  List<Interest> call() {
    return _repository.getInterests();
  }
}
