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

  PaymentMethod toEntity() {
    return PaymentMethod(
      id: id,
      title: title,
      subtitle: subtitle,
      enabled: enabled,
    );
  }
}
