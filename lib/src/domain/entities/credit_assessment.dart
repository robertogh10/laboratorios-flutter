class CreditAssessment {
  const CreditAssessment({
    required this.name,
    required this.estimatedAge,
    required this.score,
    required this.payCapacity,
    required this.approvedAmount,
  });

  final String name;
  final int estimatedAge;
  final int score;
  final int payCapacity;
  final int approvedAmount;

  bool get approved => approvedAmount > 0;
}
