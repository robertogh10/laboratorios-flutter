import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/services/credit_assessment_service.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/credit_assessment.dart';

final creditAssessmentServiceProvider = Provider<CreditAssessmentService>((
  ref,
) {
  return CreditAssessmentService();
});

final creditControllerProvider =
    AsyncNotifierProvider<CreditController, CreditAssessment?>(
      CreditController.new,
    );

class CreditController extends AsyncNotifier<CreditAssessment?> {
  @override
  Future<CreditAssessment?> build() async => null;

  Future<void> assess(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(creditAssessmentServiceProvider).assess(name);
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}
