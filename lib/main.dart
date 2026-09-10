import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:laboratorio_experinece_app/src/core/firebase_bootstrap.dart';
import 'package:laboratorio_experinece_app/src/core/local_storage.dart';
import 'package:laboratorio_experinece_app/src/core/notifications_service.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize();
  final firebaseEnabled = await FirebaseBootstrap.initializeIfConfigured();

  if (firebaseEnabled) {
    NotificationsService.registerBackgroundHandler();
  }

  runApp(
    ProviderScope(
      overrides: [firebaseEnabledProvider.overrideWithValue(firebaseEnabled)],
      child: MainApp(firebaseEnabled: firebaseEnabled),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({this.firebaseEnabled = false, super.key});

  final bool firebaseEnabled;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final _router = createAppRouter(firebaseEnabled: widget.firebaseEnabled);
  NotificationsService? _notificationsService;

  @override
  void initState() {
    super.initState();

    if (widget.firebaseEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeNotifications();
      });
    }
  }

  Future<void> _initializeNotifications() async {
    final service = NotificationsService();
    _notificationsService = service;
    final initialMessage = await service.initialize(
      onNotificationOpened: _openNotificationDestination,
      onLocalNotificationOpened: _openNotificationRoute,
    );

    if (initialMessage != null) {
      _openNotificationDestination(initialMessage);
    }
  }

  void _openNotificationDestination(RemoteMessage message) {
    final data = message.data;
    final destination = (data['route'] ?? data['pantalla'] ?? '').toString();
    final title = message.notification?.title?.toString().toLowerCase() ?? '';

    _openNotificationRoute(destination, title: title);
  }

  void _openNotificationRoute(String destination, {String title = ''}) {
    final normalized = destination.toLowerCase();

    if (normalized.contains('profile') || normalized.contains('perfil')) {
      _router.go(AppRoutes.storeProfile);
    } else if (normalized.contains('sale') ||
        normalized.contains('venta') ||
        title.contains('sale') ||
        title.contains('venta')) {
      _router.go(AppRoutes.storeSales);
    }
  }

  @override
  void dispose() {
    _notificationsService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
