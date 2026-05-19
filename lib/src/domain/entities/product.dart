import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String variant,
    required String category,
    required double price,
    required String description,
    required List<String> sizes,
    required String selectedSize,
    required List<int> colors,
    required int selectedColor,
  }) = _Product;
}
