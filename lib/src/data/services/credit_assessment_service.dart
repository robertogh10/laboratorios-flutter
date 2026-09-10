import 'package:dio/dio.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/credit_assessment.dart';

class CreditAssessmentService {
  CreditAssessmentService({Dio? dio}) : _dio = dio ?? Dio();

  static const _agifyUrl = 'https://api.agify.io';
  static const defaultPayCapacity = 60000;

  final Dio _dio;

  Future<CreditAssessment> assess(String rawName) async {
    final name = rawName.trim();

    if (name.isEmpty) {
      throw ArgumentError('Ingresa un nombre para evaluar el credito.');
    }

    final response = await _dio.get<Map<String, dynamic>>(
      _agifyUrl,
      queryParameters: {'name': name},
    );
    final age = (response.data?['age'] as num?)?.toInt();

    if (age == null) {
      throw StateError('No fue posible estimar una edad para ese nombre.');
    }

    return calculate(
      name: name,
      estimatedAge: age,
      payCapacity: defaultPayCapacity,
    );
  }

  static CreditAssessment calculate({
    required String name,
    required int estimatedAge,
    required int payCapacity,
  }) {
    final score = estimatedAge * 12;
    final approvedAmount = score > 700 && payCapacity > 50000
        ? (payCapacity * 0.2).toInt()
        : 0;

    return CreditAssessment(
      name: name,
      estimatedAge: estimatedAge,
      score: score,
      payCapacity: payCapacity,
      approvedAmount: approvedAmount,
    );
  }
}
