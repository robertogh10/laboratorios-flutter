import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class GetPaymentMethods {
  const GetPaymentMethods(this._repository);

  final StoreRepository _repository;

  List<PaymentMethod> call() {
    return _repository.getPaymentMethods();
  }
}
