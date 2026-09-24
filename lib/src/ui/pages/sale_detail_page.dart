import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/sales_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';

class SaleDetailPage extends ConsumerWidget {
  const SaleDetailPage({required this.saleId, super.key});

  final String saleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(saleDetailsProvider(saleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de compra'),
        leading: IconButton(
          tooltip: 'Volver a mis compras',
          onPressed: () => context.go(AppRoutes.storeSales),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: details.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _Message(
            text: 'No se pudo cargar la compra: $error',
            onRetry: () => ref.invalidate(saleDetailsProvider(saleId)),
          ),
          data: (sale) => sale == null
              ? const _Message(text: 'Compra no encontrada o sin acceso.')
              : _SaleSummary(sale: sale),
        ),
      ),
    );
  }
}

class _SaleSummary extends StatelessWidget {
  const _SaleSummary({required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final date = sale.createdAt.toLocal();
    final dateLabel =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF218739),
          size: 58,
        ),
        const SizedBox(height: 12),
        Text(
          'Compra registrada',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Text('Número de compra: ${sale.id}'),
        const SizedBox(height: 8),
        Text('Fecha: $dateLabel'),
        const SizedBox(height: 8),
        Text(
          'Estado: ${sale.status == 'created' ? 'Registrada' : sale.status}',
        ),
        const SizedBox(height: 8),
        Text('Método de pago: ${sale.paymentMethod}'),
        const Divider(height: 36),
        Text('Productos', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final item in sale.items)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item.product.name),
            subtitle: Text(
              '${item.product.variant} · Cantidad: ${item.quantity}',
            ),
            trailing: Text(
              '€ ${(item.product.price * item.quantity).toStringAsFixed(2)}',
            ),
          ),
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: Theme.of(context).textTheme.titleLarge),
            Text(
              '€ ${sale.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
