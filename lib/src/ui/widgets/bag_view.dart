import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/primary_button.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/store_product_image.dart';

class BagView extends StatelessWidget {
  const BagView({
    required this.items,
    required this.total,
    required this.onBack,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCheckout,
    super.key,
  });

  final List<BagItem> items;
  final double total;
  final VoidCallback onBack;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 26, 29, 28),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onBack,
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF0A7CFF),
                      size: 25,
                    ),
                  ),
                ),
                const Text(
                  'Your bag',
                  style: TextStyle(
                    color: Color(0xFF202129),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 49),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _BagItemTile(
                    item: item,
                    onIncrement: () => onIncrement(item.product.id),
                    onDecrement: () => onDecrement(item.product.id),
                  );
                },
                separatorBuilder: (context, index) =>
                    const Divider(height: 29, color: Color(0xFFE1E4EA)),
                itemCount: items.length,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    color: Color(0xFF737780),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                Text(
                  '€ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF202129),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            PrimaryButton(label: 'Checkout', onPressed: onCheckout),
          ],
        ),
      ),
    );
  }
}

class _BagItemTile extends StatelessWidget {
  const _BagItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  final BagItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final imageWidth = compact ? 88.0 : 109.0;
        final tileHeight = compact ? 112.0 : 120.0;
        final gap = compact ? 12.0 : 18.0;

        return SizedBox(
          height: tileHeight,
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                height: tileHeight,
                child: const StoreProductImage(borderRadius: 15, iconSize: 38),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF202129),
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(height: compact ? 4 : 5),
                    Text(
                      item.product.variant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF737780),
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(height: compact ? 11 : 18),
                    FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          _QuantityButton(
                            icon: Icons.remove,
                            onPressed: onDecrement,
                            compact: compact,
                          ),
                          SizedBox(width: compact ? 8 : 14),
                          Text(
                            '${item.quantity}',
                            style: TextStyle(
                              color: const Color(0xFF202129),
                              fontSize: compact ? 15 : 17,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(width: compact ? 8 : 14),
                          _QuantityButton(
                            icon: Icons.add,
                            onPressed: onIncrement,
                            compact: compact,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: compact ? 8 : 12),
              Text(
                '€ ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                style: TextStyle(
                  color: const Color(0xFF202129),
                  fontSize: compact ? 15 : 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.compact,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 24.0 : 28.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF4FF),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF0A7CFF),
          size: compact ? 17 : 19,
        ),
      ),
    );
  }
}
