import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_experinece_app/src/data/services/credit_assessment_service.dart';

void main() {
  test('approves the same score and capacity rule used by enyoi', () {
    final result = CreditAssessmentService.calculate(
      name: 'Ana',
      estimatedAge: 60,
      payCapacity: 60000,
    );

    expect(result.score, 720);
    expect(result.approved, isTrue);
    expect(result.approvedAmount, 12000);
  });

  test('denies credit when the calculated score is not above 700', () {
    final result = CreditAssessmentService.calculate(
      name: 'Luis',
      estimatedAge: 40,
      payCapacity: 60000,
    );

    expect(result.score, 480);
    expect(result.approved, isFalse);
    expect(result.approvedAmount, 0);
  });
}
