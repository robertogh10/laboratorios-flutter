# Firebase Auth + Firestore setup

## Firebase Console

1. Crea o selecciona un proyecto en Firebase Console.
2. Activa Authentication.
3. En Authentication, activa el proveedor Email/Password.
4. Activa Cloud Firestore si quieres usar el chequeo de administradores.
5. Registra las apps necesarias: Android, iOS, macOS, Web.

## Android

Descarga `google-services.json` y colocalo en:

```text
android/app/google-services.json
```

El `applicationId` del proyecto destino debe coincidir con el package registrado
en Firebase.

Verifica que Android aplique el plugin de Google Services. En proyectos Flutter
recientes con Gradle Kotlin DSL suele estar en:

```kotlin
// android/settings.gradle.kts o android/build.gradle.kts
id("com.google.gms.google-services") version "..." apply false

// android/app/build.gradle.kts
id("com.google.gms.google-services")
```

## Web u otras plataformas

Puedes pasar credenciales por `--dart-define`:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=your-api-key \
  --dart-define=FIREBASE_APP_ID=your-app-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
  --dart-define=FIREBASE_PROJECT_ID=your-project-id \
  --dart-define=FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com \
  --dart-define=FIREBASE_STORAGE_BUCKET=your-project.appspot.com
```

Obligatorios:

- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`

Si falta alguno, `FirebaseBootstrap.initializeIfConfigured()` retorna `false` y
el login queda deshabilitado para esa ejecucion.

## Administradores opcionales

La sesion calcula `isAdmin` revisando Firestore:

```text
admins/{emailNormalizado}
```

Ejemplo recomendado:

```text
admins/admin@correo.com
```

El documento puede estar vacio o incluir metadatos:

```json
{
  "email": "admin@correo.com",
  "role": "admin"
}
```

Si el proyecto destino no necesita admins, se puede quitar
`AdminAccessService`, `cloud_firestore` y el campo `isAdmin` de `AuthSession`.

## Reglas iniciales para desarrollo

Usa reglas abiertas solo de forma temporal y con fecha limite corta:

```text
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2026, 12, 31);
    }
  }
}
```

Para una base autenticada:

```text
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    function signedIn() {
      return request.auth != null;
    }

    function isAdmin() {
      return signedIn()
        && exists(/databases/$(database)/documents/admins/$(request.auth.token.email));
    }

    match /admins/{email} {
      allow read: if isAdmin();
      allow write: if false;
    }

    match /users/{userId}/{document=**} {
      allow read, write: if signedIn() && request.auth.uid == userId;
    }
  }
}
```
