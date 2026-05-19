import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/payment_method.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';

part 'store_state.freezed.dart';

enum StoreView { home, detail, bag, checkout }

@freezed
abstract class StoreState with _$StoreState {
  const factory StoreState({
    required StoreView view,
    required List<Product> products,
    required List<BagItem> bagItems,
    required List<PaymentMethod> paymentMethods,
    required String selectedProductId,
    required String selectedPaymentMethodId,
    required bool billingSameAsShipping,
  }) = _StoreState;
}
