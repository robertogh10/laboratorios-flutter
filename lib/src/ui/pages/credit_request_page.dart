import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/credit_assessment.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/credit_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';

class CreditRequestPage extends ConsumerStatefulWidget {
  const CreditRequestPage({super.key});

  @override
  ConsumerState<CreditRequestPage> createState() => _CreditRequestPageState();
}

class _CreditRequestPageState extends ConsumerState<CreditRequestPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assessment = ref.watch(creditControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver al perfil',
          onPressed: () => context.go(AppRoutes.storeProfile),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Solicita tu credito'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Ingresa tu nombre para calcular una evaluacion didactica.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            TextField(
              key: const ValueKey('credit-name-field'),
              controller: _nameController,
              textInputAction: TextInputAction.done,
              onSubmitted: assessment.isLoading ? null : (_) => _assess(),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: assessment.isLoading ? null : _assess,
              child: Text(
                assessment.isLoading ? 'Calculando...' : 'Calcular credito',
              ),
            ),
            const SizedBox(height: 28),
            assessment.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => _CreditMessage(
                icon: Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                title: 'No se pudo completar la evaluacion',
                detail: _friendlyError(error),
              ),
              data: (result) => result == null
                  ? const SizedBox.shrink()
                  : _CreditResultView(result: result),
            ),
            const SizedBox(height: 24),
            const Text(
              'Esta calculadora reproduce el laboratorio de referencia: usa '
              'una edad estimada por Agify, la convierte a puntaje (edad x 12) '
              'y aplica una capacidad de pago simulada. No es una oferta ni una '
              'evaluacion financiera real.',
              style: TextStyle(color: Color(0xFF737780), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  void _assess() {
    FocusScope.of(context).unfocus();
    ref.read(creditControllerProvider.notifier).assess(_nameController.text);
  }

  String _friendlyError(Object error) {
    if (error is DioException) {
      return 'No se pudo consultar el servicio de estimacion. Revisa tu conexion.';
    }

    return error.toString().replaceFirst('Invalid argument(s): ', '');
  }
}

class _CreditResultView extends StatelessWidget {
  const _CreditResultView({required this.result});

  final CreditAssessment result;

  @override
  Widget build(BuildContext context) {
    final approved = result.approved;

    return _CreditMessage(
      icon: approved ? Icons.check_circle_outline : Icons.cancel_outlined,
      color: approved ? const Color(0xFF218739) : const Color(0xFFC23B33),
      title: approved
          ? 'Credito aprobado: Q ${result.approvedAmount}'
          : 'Credito denegado',
      detail:
          'Edad estimada: ${result.estimatedAge} · Puntaje: ${result.score} · '
          'Capacidad simulada: Q ${result.payCapacity}',
    );
  }
}

class _CreditMessage extends StatelessWidget {
  const _CreditMessage({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
