import 'package:flutter/material.dart';

class StoreProductImage extends StatelessWidget {
  const StoreProductImage({
    this.borderRadius = 0,
    this.iconSize = 34,
    super.key,
  });

  final double borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: const Color(0xFF9DCFFF).withValues(alpha: 0.82),
          size: iconSize,
        ),
      ),
    );
  }
}
