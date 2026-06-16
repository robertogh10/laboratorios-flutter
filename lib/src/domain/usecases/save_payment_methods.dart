import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class SavePaymentMethods {
  const SavePaymentMethods(this._repository);

  final StoreRepository _repository;

  Future<void> call(List<PaymentMethod> methods) {
    return _repository.savePaymentMethods(methods);
  }
}
