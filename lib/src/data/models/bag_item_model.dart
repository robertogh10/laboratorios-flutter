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

  BagItem toEntity() {
    return BagItem(product: product.toEntity(), quantity: quantity);
  }
}
