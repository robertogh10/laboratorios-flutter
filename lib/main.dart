import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laboratorio_experinece_app/src/core/firebase_bootstrap.dart';
import 'package:laboratorio_experinece_app/src/core/local_storage.dart';
import 'package:laboratorio_experinece_app/src/ui/providers/store_provider.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';
import 'package:laboratorio_experinece_app/src/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize();
  final firebaseEnabled = await FirebaseBootstrap.initializeIfConfigured();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
