import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/product.dart';
import 'package:laboratorio_experinece_app/src/ui/widgets/store_product_image.dart';

class StoreHomeView extends StatelessWidget {
  const StoreHomeView({
    required this.products,
    required this.bagCount,
    required this.isAdmin,
    required this.onProductPressed,
    required this.onSignOut,
    required this.onBagPressed,
    required this.onSalesPressed,
    required this.onProfilePressed,
    required this.onAddProductPressed,
    super.key,
  });

  final List<Product> products;
  final int bagCount;
  final bool isAdmin;
  final ValueChanged<String> onProductPressed;
  final VoidCallback onSignOut;
  final VoidCallback onBagPressed;
  final VoidCallback onSalesPressed;
  final VoidCallback onProfilePressed;
  final VoidCallback onAddProductPressed;

  @override
  Widget build(BuildContext context) {
    final perfect = products
        .where((item) => item.category == 'perfect')
        .toList();
    final summer = products.where((item) => item.category == 'summer').toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 25, 22, 21),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: onSignOut,
                  icon: const Icon(Icons.logout, size: 27),
                ),
                const Spacer(),
                IconButton(
                  tooltip: isAdmin ? 'Live sales' : 'My purchases',
                  onPressed: onSalesPressed,
                  icon: const Icon(Icons.receipt_long_outlined, size: 27),
                ),
                const SizedBox(width: 8),
                if (isAdmin) ...[
                  _AdminAddButton(onPressed: onAddProductPressed),
                  const SizedBox(width: 10),
                ] else ...[
                  const SizedBox(width: 4),
                ],
                _BagButton(count: bagCount, onPressed: onBagPressed),
              ],
            ),
          ),
          const Expanded(flex: 34, child: _HeroCarousel()),
          Expanded(
            flex: 61,
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(20, 27, 0, 106),
                  children: [
                    _SectionHeader(title: 'Perfect for you'),
                    const SizedBox(height: 18),
                    _ProductRow(
                      products: perfect,
                      onProductPressed: onProductPressed,
                    ),
                    const SizedBox(height: 46),
                    _SectionHeader(title: 'For this summer'),
                    const SizedBox(height: 18),
                    _ProductRow(
                      products: summer,
                      onProductPressed: onProductPressed,
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _StoreBottomNavigation(
                    onProfilePressed: onProfilePressed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminAddButton extends StatelessWidget {
  const _AdminAddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Add product',
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFEAF4FF),
        foregroundColor: const Color(0xFF0A7CFF),
        fixedSize: const Size.square(42),
      ),
      icon: const Icon(Icons.add, size: 25),
    );
  }
}

class _BagButton extends StatelessWidget {
  const _BagButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              left: 1,
              top: 3,
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 31,
                color: Color(0xFF202129),
              ),
            ),
            Positioned(
              right: -3,
              bottom: 1,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A7CFF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        StoreProductImage(iconSize: 38),
        Positioned(left: 0, right: 0, bottom: 17, child: _CarouselDots()),
      ],
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CarouselDot(color: Color(0xFFD8DEE8)),
        SizedBox(width: 8),
        _CarouselDot(color: Color(0xFF0A7CFF)),
        SizedBox(width: 8),
        _CarouselDot(color: Color(0xFFD8DEE8)),
        SizedBox(width: 8),
        _CarouselDot(color: Color(0xFFD8DEE8)),
        SizedBox(width: 8),
        _CarouselDot(color: Color(0xFFD8DEE8)),
      ],
    );
  }
}

class _CarouselDot extends StatelessWidget {
  const _CarouselDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: const SizedBox.square(dimension: 9),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF111217),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'See more',
            style: TextStyle(
              color: Color(0xFF0A7CFF),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatefulWidget {
  const _ProductRow({required this.products, required this.onProductPressed});

  final List<Product> products;
  final ValueChanged<String> onProductPressed;

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: ScrollConfiguration(
          behavior: const _HorizontalProductScrollBehavior(),
          child: ListView.separated(
            controller: _scrollController,
            primary: false,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(right: 20),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return _ProductCard(
                product: product,
                onPressed: () => widget.onProductPressed(product.id),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemCount: widget.products.length,
          ),
        ),
      ),
    );
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    final delta = event.scrollDelta.dy == 0
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    final offset = (_scrollController.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    _scrollController.jumpTo(offset);
  }
}

class _HorizontalProductScrollBehavior extends MaterialScrollBehavior {
  const _HorizontalProductScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      ...super.dragDevices,
      PointerDeviceKind.mouse,
      PointerDeviceKind.trackpad,
    };
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onPressed});

  final Product product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FC),
          borderRadius: BorderRadius.circular(17),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: StoreProductImage(iconSize: 38)),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF202129),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '€ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF202129),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreBottomNavigation extends StatelessWidget {
  const _StoreBottomNavigation({required this.onProfilePressed});

  final VoidCallback onProfilePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(31, 13, 31, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _NavItem(icon: Icons.explore, label: 'Explore', selected: true),
          const _NavItem(
            icon: Icons.grid_view_rounded,
            label: 'Categories',
            selected: false,
          ),
          const _NavItem(icon: Icons.store, label: 'Stores', selected: false),
          _NavItem(
            icon: Icons.person,
            label: 'Profile',
            selected: false,
            onPressed: onProfilePressed,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0A7CFF) : const Color(0xFFC8CDD6);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 9),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF202129)
                    : const Color(0xFF8D929C),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
