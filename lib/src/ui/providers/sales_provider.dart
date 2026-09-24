import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/sales_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/sales_firebase_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/sales_local_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/sale_model.dart';
import 'package:laboratorio_experinece_app/src/data/repositories/sales_repository_impl.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/auth_session.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/sales_repository.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/create_sale.dart';
import 'package:laboratorio_experinece_app/src/domain/usecases/watch_sales.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/auth_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';

final salesLocalDataSourceProvider = Provider<SalesLocalDataSource>((ref) {
  return SalesLocalDataSource();
});

final salesDataSourceProvider = Provider<SalesDataSource>((ref) {
  if (ref.watch(firebaseEnabledProvider)) {
    return SalesFirebaseDataSource(firestore: ref.watch(firestoreProvider));
  }

  return ref.watch(salesLocalDataSourceProvider);
});

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  return SalesRepositoryImpl(ref.watch(salesDataSourceProvider));
});

final createSaleProvider = Provider<CreateSale>((ref) {
  return CreateSale(ref.watch(salesRepositoryProvider));
});

final watchSalesProvider = Provider<WatchSales>((ref) {
  return WatchSales(ref.watch(salesRepositoryProvider));
});

final salesStreamProvider = StreamProvider<List<Sale>>((ref) async* {
  final session = await _currentSession(ref);

  if (session == null) {
    yield const [];
    return;
  }

  yield* ref.watch(watchSalesProvider)(
    userId: session.uid,
    isAdmin: session.isAdmin,
  );
});

final saleDetailsProvider = FutureProvider.family<Sale?, String>((
  ref,
  saleId,
) async {
  final session = await _currentSession(ref);
  if (session == null || saleId.isEmpty) return null;

  if (ref.read(firebaseEnabledProvider)) {
    final document = await ref
        .read(firestoreProvider)
        .collection('sales')
        .doc(saleId)
        .get();
    if (!document.exists || document.data() == null) return null;
    final sale = SaleModel.fromJson(
      id: document.id,
      json: document.data()!,
    ).toEntity();
    return sale.userId == session.uid || session.isAdmin ? sale : null;
  }

  final sales = await ref
      .read(watchSalesProvider)(userId: session.uid, isAdmin: session.isAdmin)
      .first;
  for (final sale in sales) {
    if (sale.id == saleId) return sale;
  }
  return null;
});

final salesControllerProvider = AsyncNotifierProvider<SalesController, void>(
  SalesController.new,
);

class SalesController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Sale?> checkout() async {
    final storeState = ref.read(storeControllerProvider).asData?.value;

    if (storeState == null || storeState.bagItems.isEmpty) {
      state = AsyncError(
        StateError('Tu carrito esta vacio.'),
        StackTrace.current,
      );
      return null;
    }

    final session = await _currentSession(ref);

    if (session == null) {
      state = AsyncError(
        StateError('Inicia sesion para completar la compra.'),
        StackTrace.current,
      );
      return null;
    }

    final selectedMethods = storeState.paymentMethods.where(
      (method) => method.id == storeState.selectedPaymentMethodId,
    );

    if (selectedMethods.isEmpty) {
      state = AsyncError(
        StateError('Selecciona un metodo de pago.'),
        StackTrace.current,
      );
      return null;
    }

    state = const AsyncLoading();

    try {
      final sale = Sale(
        id: '',
        userId: session.uid,
        userEmail: session.email,
        items: List.unmodifiable(storeState.bagItems),
        total: storeState.bagItems.fold<double>(
          0,
          (sum, item) => sum + item.product.price * item.quantity,
        ),
        paymentMethod: selectedMethods.first.title,
        status: 'created',
        createdAt: DateTime.now().toUtc(),
      );

      final createdSale = await ref.read(createSaleProvider)(sale);
      await ref.read(storeControllerProvider.notifier).clearBag();
      state = const AsyncData(null);

      return createdSale;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }
}

Future<AuthSession?> _currentSession(Ref ref) async {
  if (!ref.read(firebaseEnabledProvider)) {
    return const AuthSession(
      uid: 'demo-user',
      email: 'demo@local',
      isAdmin: false,
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return null;
  }

  return ref.read(authSessionProvider.future);
}
