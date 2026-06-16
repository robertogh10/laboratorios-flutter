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

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      variant: product.variant,
      category: product.category,
      price: product.price,
      description: product.description,
      sizes: product.sizes,
      selectedSize: product.selectedSize,
      colors: product.colors,
      selectedColor: product.selectedColor,
    );
  }

  factory ProductModel.fromJson(Map<String, Object?> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      variant: json['variant'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      sizes: (json['sizes'] as List).cast<String>(),
      selectedSize: json['selectedSize'] as String,
      colors: (json['colors'] as List)
          .map((color) => (color as num).toInt())
          .toList(),
      selectedColor: (json['selectedColor'] as num).toInt(),
    );
  }

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

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'variant': variant,
      'category': category,
      'price': price,
      'description': description,
      'sizes': sizes,
      'selectedSize': selectedSize,
      'colors': colors,
      'selectedColor': selectedColor,
    };
  }
}
