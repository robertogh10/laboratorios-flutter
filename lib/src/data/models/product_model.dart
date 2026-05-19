import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';

part 'product_model.freezed.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
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
  }) = _ProductModel;

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      variant: variant,
      category: category,
      price: price,
      description: description,
      sizes: sizes,
      selectedSize: selectedSize,
      colors: colors,
      selectedColor: selectedColor,
    );
  }
}
