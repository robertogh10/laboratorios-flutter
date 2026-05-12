import 'package:laboratorio_experinece_app/src/data/datasources/onboarding_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/interest.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._dataSource);

  final OnboardingLocalDataSource _dataSource;

  @override
  List<Interest> getInterests() {
    return _dataSource.getInterests().map((model) => model.toEntity()).toList();
  }
}
