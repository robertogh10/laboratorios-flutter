import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';

class SalesStreamView extends StatelessWidget {
  const SalesStreamView({
    required this.sales,
    required this.isAdmin,
    required this.onBack,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<List<Sale>> sales;
  final bool isAdmin;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 24, 14),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isAdmin ? 'Live sales' : 'My purchases',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 25),
                  ),
                ),
                const _LiveIndicator(),
              ],
            ),
          ),
          Expanded(
            child: sales.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  _SalesError(message: error.toString(), onRetry: onRetry),
              data: (items) {
                if (items.isEmpty) {
                  return _EmptySales(isAdmin: isAdmin);
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _SaleCard(sale: items[index], showUser: isAdmin);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  const _LiveIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F8ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF28A745),
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(dimension: 7),
          ),
          SizedBox(width: 6),
          Text(
            'LIVE',
            style: TextStyle(
              color: Color(0xFF237A3B),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.sale, required this.showUser});

  final Sale sale;
  final bool showUser;

  @override
  Widget build(BuildContext context) {
    final localDate = sale.createdAt.toLocal();
    final date =
        '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
    final unitCount = sale.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE1E4EA)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF0A7CFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sale #${sale.id.length > 8 ? sale.id.substring(0, 8) : sale.id}',
                      style: const TextStyle(
                        color: Color(0xFF202129),
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF737780),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '€ ${sale.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF202129),
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$unitCount item${unitCount == 1 ? '' : 's'} · ${sale.paymentMethod} · ${sale.status}',
            style: const TextStyle(color: Color(0xFF737780), fontSize: 13),
          ),
          if (showUser) ...[
            const SizedBox(height: 6),
            Text(
              sale.userEmail.isEmpty ? sale.userId : sale.userEmail,
              style: const TextStyle(
                color: Color(0xFF0A7CFF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptySales extends StatelessWidget {
  const _EmptySales({required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          isAdmin
              ? 'Las nuevas compras apareceran aqui en tiempo real.'
              : 'Todavia no has realizado ninguna compra.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class _SalesError extends StatelessWidget {
  const _SalesError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No se pudo cargar el stream de compras.'),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
