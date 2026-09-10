# Firebase login migration pack

Esta carpeta contiene todo lo necesario para migrar la logica de login con
Firebase Auth de este proyecto a otro proyecto Flutter.

## Que contiene

```text
firebase_login_migration/
  portable/
    lib/src/core/
      firebase_bootstrap.dart
      firebase_environment_options.dart
    lib/src/domain/entities/
      auth_session.dart
    lib/src/data/services/
      admin_access_service.dart
    lib/src/ui/providers/
      firebase_enabled_provider.dart
      auth_provider.dart
    lib/src/ui/pages/
      auth_page.dart
    lib/src/ui/widgets/
      primary_button.dart
    lib/src/ui/routing/
      auth_router_snippet.dart
    main_bootstrap_example.dart
    pubspec_dependencies.yaml
  original_project_files/
    ...
  docs/
    firebase_auth_firestore_setup.md
    integration_checklist.md
```

## Usar en otro proyecto

1. Entrega esta carpeta completa al agente del otro proyecto.
2. Pidele que empiece por `docs/integration_checklist.md`.
3. Que use `portable/` como base de implementacion.
4. Que revise `original_project_files/` solo si necesita entender como estaba
   conectado en esta app.

## Alcance

El login migrado incluye:

- Inicializacion condicional de Firebase.
- Login con Email/Password.
- Registro con Email/Password.
- Logout.
- Provider de sesion actual.
- Mensajes amigables para errores comunes de Firebase Auth.
- Ruta/pantalla de login y registro.
- Guard de rutas protegidas con `go_router`.
- Chequeo opcional de administradores en Firestore.

## Notas

- No se incluyen credenciales reales de Firebase.
- El proyecto destino debe configurar sus propias apps en Firebase Console.
- El codigo portable evita imports al package de esta app para que sea mas facil
  copiarlo.
- Si el proyecto destino ya tiene Riverpod/router/design system, conviene
  adaptar los providers y la UI a sus patrones existentes.
