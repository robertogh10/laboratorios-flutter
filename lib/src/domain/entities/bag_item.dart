import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';

part 'bag_item.freezed.dart';

@freezed
abstract class BagItem with _$BagItem {
  const factory BagItem({required Product product, required int quantity}) =
      _BagItem;
}
