import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/store_product_image.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({
    required this.product,
    required this.isAdmin,
    required this.onClose,
    required this.onFavoritePressed,
    required this.onEditPressed,
    required this.onSizeSelected,
    required this.onColorSelected,
    required this.onAddToBag,
    super.key,
  });

  final Product product;
  final bool isAdmin;
  final VoidCallback onClose;
  final VoidCallback onFavoritePressed;
  final VoidCallback onEditPressed;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<int> onColorSelected;
  final VoidCallback onAddToBag;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 430;

          return Column(
            children: [
              Expanded(
                flex: isNarrow ? 35 : 43,
                child: Stack(
                  children: [
                    const StoreProductImage(iconSize: 42),
                    Positioned(
                      left: 22,
                      top: 24,
                      child: GestureDetector(
                        onTap: onClose,
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(
                          Icons.close,
                          size: 31,
                          color: Color(0xFF202129),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 17,
                      child: _DetailDots(),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: isNarrow ? 65 : 58,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, isNarrow ? 22 : 28, 30, 28),
                  child: _ProductDetailContent(
                    product: product,
                    compact: isNarrow,
                    isAdmin: isAdmin,
                    onFavoritePressed: onFavoritePressed,
                    onEditPressed: onEditPressed,
                    onSizeSelected: onSizeSelected,
                    onColorSelected: onColorSelected,
                    onAddToBag: onAddToBag,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({
    required this.product,
    required this.compact,
    required this.isAdmin,
    required this.onFavoritePressed,
    required this.onEditPressed,
    required this.onSizeSelected,
    required this.onColorSelected,
    required this.onAddToBag,
  });

  final Product product;
  final bool compact;
  final bool isAdmin;
  final VoidCallback onFavoritePressed;
  final VoidCallback onEditPressed;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<int> onColorSelected;
  final VoidCallback onAddToBag;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Color(0xFF202129),
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Text(
                        '€ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF202129),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: isAdmin ? onEditPressed : onFavoritePressed,
                  child: Icon(
                    isAdmin ? Icons.edit_outlined : Icons.favorite_border,
                    size: 31,
                    color: const Color(0xFF202129),
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 20 : 30),
            Text(
              product.description,
              maxLines: compact ? 4 : null,
              overflow: compact ? TextOverflow.ellipsis : null,
              style: TextStyle(
                color: const Color(0xFF737780),
                fontSize: compact ? 15 : 16,
                fontWeight: FontWeight.w400,
                height: 1.22,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: compact ? 20 : 33),
            const Text(
              'Size',
              style: TextStyle(
                color: Color(0xFF202129),
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 11),
            _SizeSelector(product: product, onSelected: onSizeSelected),
            SizedBox(height: compact ? 22 : 35),
            const Text(
              'Color',
              style: TextStyle(
                color: Color(0xFF202129),
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 13),
            _ColorSelector(product: product, onSelected: onColorSelected),
          ],
        );

        if (compact || constraints.maxHeight < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: content,
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(label: '+  Add to bag', onPressed: onAddToBag),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            const Spacer(),
            PrimaryButton(label: '+  Add to bag', onPressed: onAddToBag),
          ],
        );
      },
    );
  }
}

class _DetailDots extends StatelessWidget {
  const _DetailDots();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(color: Color(0xFFD8DEE8)),
        SizedBox(width: 8),
        _Dot(color: Color(0xFF0A7CFF)),
        SizedBox(width: 8),
        _Dot(color: Color(0xFFD8DEE8)),
        SizedBox(width: 8),
        _Dot(color: Color(0xFFD8DEE8)),
        SizedBox(width: 8),
        _Dot(color: Color(0xFFD8DEE8)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox.square(dimension: 9),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({required this.product, required this.onSelected});

  final Product product;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: product.sizes.map((size) {
        final selected = size == product.selectedSize;

        return Padding(
          padding: const EdgeInsets.only(right: 13),
          child: GestureDetector(
            key: ValueKey('product-size-$size'),
            onTap: () => onSelected(size),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 45,
              height: 29,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0A7CFF)
                    : const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  size,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF0A7CFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({required this.product, required this.onSelected});

  final Product product;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: product.colors.map((colorValue) {
        final selected = colorValue == product.selectedColor;

        return Padding(
          padding: const EdgeInsets.only(right: 14),
          child: GestureDetector(
            key: ValueKey(
              'product-color-${colorValue.toUnsigned(32).toRadixString(16)}',
            ),
            onTap: () => onSelected(colorValue),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(colorValue),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 42),
                  ),
                  if (selected)
                    const Positioned(
                      right: -1,
                      top: -4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFF0A7CFF),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
