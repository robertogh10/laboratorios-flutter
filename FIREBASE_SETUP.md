# Firebase setup

La app puede trabajar con Firebase Authentication y Cloud Firestore, pero
Firebase queda apagado mientras no existan credenciales. En ese modo muestra un
acceso demo y usa `StoreLocalDataSource` como fallback local.

## 1. Crear el proyecto

1. Crea un proyecto en Firebase Console.
2. Activa Authentication con Email/Password.
3. Activa Cloud Firestore.
4. Registra las apps que necesites: Android, iOS, macOS y/o Web.
5. Copia los valores de configuracion de Firebase.

## 2. Ejecutar con Firebase activo en Android

Para Android, descarga `google-services.json` desde Firebase Console y colocalo
en:

```text
android/app/google-services.json
```

La app Android ya tiene aplicado el plugin `com.google.gms.google-services`, asi
que puede inicializar Firebase directamente desde ese archivo:

```bash
flutter run -d android
```

El `applicationId` actual de Android es:

```text
com.example.laboratorio_experinece_app
```

El package name registrado en Firebase debe coincidir exactamente con ese valor.

## 3. Ejecutar con Firebase activo en Web u otras plataformas

Pasa los valores como `--dart-define`:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=your-api-key \
  --dart-define=FIREBASE_APP_ID=your-app-id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \
  --dart-define=FIREBASE_PROJECT_ID=your-project-id \
  --dart-define=FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com \
  --dart-define=FIREBASE_STORAGE_BUCKET=your-project.appspot.com
```

Los valores obligatorios son:

- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`

Si falta alguno, la app no inicializa Firebase y sigue usando almacenamiento
local.

En Android, estos valores ya vienen del `google-services.json`, por lo que no
necesitas pasarlos manualmente salvo que quieras sobreescribir la configuracion.

## 4. Estructura de Firestore

La app espera estas colecciones:

```text
products/{productId}
admins/{emailNormalizado}
users/{uid}/bagItems/{bagItemId}
users/{uid}/paymentMethods/{methodId}
```

`uid` sale de Firebase Auth. Si Firebase no esta configurado, la app usa
`demo-user` solamente para el modo demo local.

Para admins, la forma recomendada es usar el correo en minusculas como ID del
documento:

```text
admins/admin@correo.com
```

El documento puede estar vacio o tener metadatos:

```json
{
  "email": "admin@correo.com",
  "role": "admin"
}
```

La app tambien acepta documentos en `admins` que tengan un campo `email`, por si
tu coleccion actual ya esta guardada con IDs automaticos.

## 5. Documento de producto

Ejemplo para `products/amazing-shirt`:

```json
{
  "name": "Amazing T-shirt",
  "variant": "Black / M",
  "category": "perfect",
  "price": 20,
  "description": "The perfect T-shirt for daily outfits.",
  "sizes": ["XS", "S", "M", "L", "XL"],
  "selectedSize": "S",
  "colors": [4280295721, 4286024065, 4290296512, 4293187311],
  "selectedColor": 4290296512
}
```

Campos obligatorios:

- `name`: string
- `variant`: string
- `category`: string
- `price`: number
- `description`: string
- `sizes`: array de strings
- `selectedSize`: string
- `colors`: array de numeros ARGB, por ejemplo `4280295721`
- `selectedColor`: numero ARGB incluido en `colors`

Si `products` esta vacia, la app muestra los productos locales de ejemplo para
que el flujo siga funcionando.

## 6. Documento de carrito

La app guarda cada item del carrito en `users/{uid}/bagItems/{bagItemId}`:

```json
{
  "product": {
    "id": "amazing-shirt-XL-ff202129",
    "name": "Amazing T-shirt",
    "variant": "Black / XL",
    "category": "perfect",
    "price": 20,
    "description": "The perfect T-shirt for daily outfits.",
    "sizes": ["XS", "S", "M", "L", "XL"],
    "selectedSize": "XL",
    "colors": [4280295721, 4286024065],
    "selectedColor": 4280295721
  },
  "quantity": 1
}
```

## 7. Documento de metodo de pago

La app guarda metodos en `users/{uid}/paymentMethods/{methodId}`:

```json
{
  "title": "Visa",
  "subtitle": "xxxx xxxx xxxx 1234",
  "enabled": true
}
```

No guardes numeros de tarjeta reales en Firestore.

## 8. Reglas temporales para pruebas

Para desarrollo inicial puedes usar reglas abiertas con fecha limite corta:

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

Antes de publicar la app, reemplaza esas reglas por reglas con autenticacion.
Una base razonable es permitir lectura de productos a usuarios autenticados,
permitir que cada usuario escriba solo bajo su propio UID y proteger `admins`.
