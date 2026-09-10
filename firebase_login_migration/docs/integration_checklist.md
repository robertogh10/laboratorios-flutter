# Integration checklist

## Copiar dependencias

Agrega al `pubspec.yaml` del proyecto destino las dependencias de:

```text
firebase_login_migration/portable/pubspec_dependencies.yaml
```

Luego ejecuta:

```bash
flutter pub get
```

## Copiar codigo

Copia el contenido de:

```text
firebase_login_migration/portable/lib/src
```

al `lib/src` del proyecto destino, o ajusta las rutas si el proyecto usa otra
arquitectura.

## Inicializar Firebase

En `main.dart`, antes de `runApp`, llama:

```dart
WidgetsFlutterBinding.ensureInitialized();
final firebaseEnabled = await FirebaseBootstrap.initializeIfConfigured();
```

Y registra el estado en Riverpod:

```dart
ProviderScope(
  overrides: [
    firebaseEnabledProvider.overrideWithValue(firebaseEnabled),
  ],
  child: const TargetApp(),
);
```

Hay un ejemplo completo en:

```text
firebase_login_migration/portable/main_bootstrap_example.dart
```

## Conectar rutas

Si el proyecto usa `go_router`, puedes usar o adaptar:

```text
firebase_login_migration/portable/lib/src/ui/routing/auth_router_snippet.dart
```

El helper agrega:

- `/auth/login`
- `/auth/register`
- redireccion de rutas protegidas a login
- redireccion de login/register al home cuando ya hay usuario

Ejemplo de uso:

```dart
final router = createFirebaseLoginRouter(
  initialLocation: '/home',
  signedInHomePath: '/home',
  protectedPathPrefixes: ['/home', '/profile'],
  firebaseEnabled: firebaseEnabled,
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
```

Si el proyecto no usa `go_router`, conserva `AuthController` y reemplaza los
`context.go(...)` de `AuthPage` por el sistema de navegacion del destino.

## Leer sesion actual

Para reaccionar al usuario autenticado:

```dart
final authSession = ref.watch(authSessionProvider);
```

`AuthSession` contiene:

- `uid`
- `email`
- `isAdmin`

## Logout

Desde cualquier `ConsumerWidget` o `ConsumerState`:

```dart
await ref.read(authControllerProvider.notifier).signOut();
```

Si el proyecto destino debe limpiar caches al hacer login/logout, sobreescribe
`afterAuthChangedProvider`:

```dart
ProviderScope(
  overrides: [
    afterAuthChangedProvider.overrideWithValue((ref) {
      ref.invalidate(miProviderDeDatosDelUsuario);
    }),
  ],
  child: const TargetApp(),
);
```

## Ajustes esperados

- Cambiar textos ingles/espanol de `AuthPage` segun la app destino.
- Adaptar colores y `PrimaryButton` al design system del destino.
- Decidir si se mantiene modo demo con `demoRoute`.
- Quitar `AdminAccessService` si no hay roles admin.
- Reemplazar rutas por las rutas reales del proyecto destino.
