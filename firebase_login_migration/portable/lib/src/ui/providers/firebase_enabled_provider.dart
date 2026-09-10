import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseEnabledProvider = Provider<bool>((ref) => false);

typedef AfterAuthChanged = void Function(Ref ref);

final afterAuthChangedProvider = Provider<AfterAuthChanged?>((ref) => null);
