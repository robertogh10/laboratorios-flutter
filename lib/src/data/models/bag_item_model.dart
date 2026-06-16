import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:laboratorio_experinece_app/src/data/models/product_model.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';

part 'bag_item_model.freezed.dart';

@freezed
abstract class BagItemModel with _$BagItemModel {
  const BagItemModel._();

  const factory BagItemModel({
    required ProductModel product,
    required int quantity,
  }) = _BagItemModel;

  factory BagItemModel.fromEntity(BagItem item) {
    return BagItemModel(
      product: ProductModel.fromEntity(item.product),
      quantity: item.quantity,
    );
  }

  factory BagItemModel.fromJson(Map<String, Object?> json) {
    return BagItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, Object?>),
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  BagItem toEntity() {
    return BagItem(product: product.toEntity(), quantity: quantity);
  }

  Map<String, Object?> toJson() {
    return {'quantity': quantity, 'product': product.toJson()};
  }
}
