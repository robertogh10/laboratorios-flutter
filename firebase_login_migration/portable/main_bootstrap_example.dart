import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lib/src/core/firebase_bootstrap.dart';
import 'lib/src/ui/providers/firebase_enabled_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebaseEnabled = await FirebaseBootstrap.initializeIfConfigured();

  runApp(
    ProviderScope(
      overrides: [firebaseEnabledProvider.overrideWithValue(firebaseEnabled)],
      child: const TargetApp(),
    ),
  );
}

class TargetApp extends StatelessWidget {
  const TargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError(
      'Conecta aqui el MaterialApp.router del proyecto.',
    );
  }
}
