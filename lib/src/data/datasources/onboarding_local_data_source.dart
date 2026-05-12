import 'package:laboratorio_experinece_app/src/data/models/interest_model.dart';

class OnboardingLocalDataSource {
  const OnboardingLocalDataSource();

  List<InterestModel> getInterests() {
    return const [
      InterestModel(id: 'ui', title: 'User Interface', selected: true),
      InterestModel(id: 'ux', title: 'User Experience', selected: false),
      InterestModel(id: 'research', title: 'User Research', selected: true),
      InterestModel(id: 'writing', title: 'UX Writing', selected: false),
      InterestModel(id: 'testing', title: 'User Testing', selected: false),
      InterestModel(id: 'service', title: 'Service Design', selected: false),
      InterestModel(id: 'strategy', title: 'Strategy', selected: true),
      InterestModel(id: 'systems', title: 'Design Systems', selected: true),
    ];
  }
}
