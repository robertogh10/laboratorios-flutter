import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';

part 'payment_method_model.freezed.dart';

@freezed
abstract class PaymentMethodModel with _$PaymentMethodModel {
  const PaymentMethodModel._();

  const factory PaymentMethodModel({
    required String id,
    required String title,
    required String subtitle,
    required bool enabled,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromEntity(PaymentMethod method) {
    return PaymentMethodModel(
      id: method.id,
      title: method.title,
      subtitle: method.subtitle,
      enabled: method.enabled,
    );
  }

  factory PaymentMethodModel.fromJson(Map<String, Object?> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      enabled: json['enabled'] as bool,
    );
  }

  PaymentMethod toEntity() {
    return PaymentMethod(
      id: id,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'title': title, 'subtitle': subtitle, 'enabled': enabled};
  }
}
