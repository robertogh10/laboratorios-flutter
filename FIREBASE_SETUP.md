# Configuracion de Firebase paso a paso

La app puede trabajar con Firebase Authentication y Cloud Firestore, pero
Firebase queda apagado mientras no existan credenciales. En ese modo muestra un
acceso demo y usa `StoreLocalDataSource` como fallback local.

## 1. Crear o seleccionar el proyecto

1. Entra a [Firebase Console](https://console.firebase.google.com/).
2. Crea un proyecto o selecciona el proyecto que usaras.
3. En `Project settings > General`, registra las apps que necesites.

En este repositorio ya se detecto una configuracion Android para:

```text
Project ID: laboratorio-experience-app
Package name: com.example.laboratorio_experinece_app
```

Puedes continuar con ese proyecto. Si registras otra app Android, su package
name debe coincidir exactamente con el `applicationId` anterior.

## 2. Activar Authentication

1. En Firebase Console abre `Build > Authentication`.
2. Presiona `Get started`.
3. Abre `Sign-in method`.
4. Selecciona `Email/Password`.
5. Activa la primera opcion `Email/Password` y guarda.

Los clientes pueden registrarse desde la propia app. Para crear un usuario de
prueba manualmente, abre `Authentication > Users > Add user` e ingresa correo y
contrasena.

## 3. Crear Cloud Firestore

1. Abre `Build > Firestore Database`.
2. Presiona `Create database`.
3. Elige la ubicacion mas cercana a tus usuarios. Esa ubicacion no se puede
   cambiar posteriormente.
4. Selecciona modo de produccion.
5. Abre la pestana `Rules`.
6. Copia el contenido completo de `firestore.rules` de este repositorio, pegalo
   en el editor y presiona `Publish`.

Si ya tienes Firebase CLI instalado y autenticado, el `firebase.json` incluido
permite publicar las mismas reglas desde la raiz del proyecto:

```bash
firebase deploy --only firestore:rules --project laboratorio-experience-app
```

## 4. Conectar Android

Para Android, descarga `google-services.json` desde Firebase Console y colocalo
en:

```text
android/app/google-services.json
```

La app Android ya tiene aplicado el plugin `com.google.gms.google-services`, asi
que puede inicializar Firebase directamente desde ese archivo:

```bash
flutter devices
flutter run -d <device-id>
```

El `applicationId` actual de Android es:

```text
com.example.laboratorio_experinece_app
```

El package name registrado en Firebase debe coincidir exactamente con ese valor.

## 5. Conectar iOS, macOS o Web

Para iOS:

1. Registra el bundle ID `com.example.laboratorioExperineceApp`.
2. Descarga `GoogleService-Info.plist`.
3. Abre `ios/Runner.xcworkspace` con Xcode.
4. Arrastra el archivo dentro de `Runner` y marca `Copy items if needed`.

Para macOS repite el proceso dentro del target `macos/Runner`.

Para Web y Windows, o si prefieres no agregar archivos nativos, pasa los valores
como `--dart-define`:

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

## 6. Crear el administrador

Primero registra o crea el usuario en Authentication. Luego:

1. En `Authentication > Users`, copia su `User UID`.
2. En `Firestore Database > Data`, crea la coleccion `admins`.
3. Crea un documento cuyo `Document ID` sea exactamente el UID copiado.
4. Agrega estos campos opcionales:

```json
{
  "email": "admin@correo.com",
  "role": "admin"
}
```

La app tambien soporta, por compatibilidad, un documento cuyo ID sea el correo
en minusculas (`admins/admin@correo.com`). Usar el UID es la opcion recomendada:
no depende de cambios de correo ni de diferencias entre mayusculas y minusculas.

No crees administradores desde el cliente. Las reglas incluidas impiden que la
app se otorgue ese rol a si misma.

## 7. Estructura de Firestore

La app espera estas colecciones:

```text
products/{productId}
admins/{uid}
users/{uid}/bagItems/{bagItemId}
users/{uid}/paymentMethods/{methodId}
sales/{saleId}
```

`uid` sale de Firebase Auth. Si Firebase no esta configurado, la app usa
`demo-user` solamente para el modo demo local.

El documento principal del usuario tambien puede contener:

```text
users/{uid} -> email, displayName, profileImageUrl, fcmToken,
               fcmTokenUpdatedAt, updatedAt
```

## 8. Administracion de productos en la app

Cuando un usuario inicia sesion, la app revisa si su correo existe en
`admins` usando primero su UID y, por compatibilidad, su correo. Si existe, la
pantalla de tienda muestra:

- Un boton `+` en la parte superior para crear productos.
- Un boton de editar en el detalle del producto.

El formulario guarda en:

```text
products/{productId}
```

Para que un usuario vea estas opciones, crea su documento `admins/{uid}` como se
explica en el paso 6.

## 9. Crear productos

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

Puedes crear el primer producto manualmente en Firebase Console o iniciar sesion
como administrador y usar el boton `+`. La edicion se abre desde el detalle del
producto.

## 10. Documento de carrito

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

## 11. Documento de metodo de pago

La app guarda metodos en `users/{uid}/paymentMethods/{methodId}`:

```json
{
  "title": "Visa",
  "subtitle": "xxxx xxxx xxxx 1234",
  "enabled": true
}
```

No guardes numeros de tarjeta reales en Firestore.

## 12. Stream de compras

Al presionar `Continue` en checkout, la app crea un documento con ID automatico
en `sales`. Ejemplo:

```json
{
  "userId": "UID_DEL_COMPRADOR",
  "userEmail": "cliente@correo.com",
  "items": [
    {
      "quantity": 1,
      "product": {
        "id": "amazing-shirt-M-ff202129",
        "name": "Amazing T-shirt",
        "variant": "Black / M",
        "category": "perfect",
        "price": 20,
        "description": "The perfect T-shirt for daily outfits.",
        "sizes": ["S", "M", "L"],
        "selectedSize": "M",
        "colors": [4280295721],
        "selectedColor": 4280295721
      }
    }
  ],
  "total": 20,
  "paymentMethod": "Visa",
  "status": "created",
  "createdAt": "Firestore Timestamp"
}
```

El icono de recibo abre el stream:

- Un cliente recibe en tiempo real solo documentos cuyo `userId` sea su UID.
- Un administrador recibe en tiempo real todas las ventas.
- Al completarse la compra se limpia `users/{uid}/bagItems`.

No debes crear indices compuestos para esta consulta: el orden se aplica en el
cliente.

## 13. Reglas de seguridad

El archivo listo para publicar esta en `firestore.rules`. Su contenido permite:

- Leer productos solo con sesion iniciada.
- Crear o editar productos solo a administradores.
- Leer/escribir carrito y metodos solo al propietario.
- Crear ventas solo con el UID de la sesion.
- Leer ventas propias o, para administradores, todas las ventas.
- Leer el documento de rol propio, sin permitir que la app cree admins.

No uses reglas abiertas con `allow read, write: if true`.

## 14. Activar Storage para la foto de perfil

1. Abre `Build > Storage` y crea el bucket del proyecto.
2. Publica `storage.rules` junto con las reglas de Firestore:

```bash
firebase deploy --only firestore:rules,storage --project laboratorio-experience-app
```

La app guarda una sola imagen por usuario en
`profile_images/{uid}/avatar`. Las reglas limitan escritura al propietario,
aceptan solo imagenes y fijan un maximo de 5 MB.

## 15. Activar Cloud Messaging

En Android, el `google-services.json` existente aporta el Sender ID. En Android
13 o posterior el sistema pedira permiso de notificaciones. Comprueba en
`Project settings > Cloud Messaging` que Cloud Messaging API este habilitada.

Para iOS, ademas del `GoogleService-Info.plist`:

1. Activa `Push Notifications` y `Background Modes > Remote notifications` en
   el target Runner de Xcode.
2. Sube a Firebase la llave APNs (`.p8`) o el certificado correspondiente.
3. Prueba en un dispositivo fisico.

Tras iniciar sesion, la app escribe el token en `users/{uid}.fcmToken`. Una
notificacion puede incluir `data.route = "sales"` o `"profile"` para abrir esa
seccion al tocarla. Puedes probar desde Firebase Console. Para envios
automaticos usa Cloud Functions o un backend con Admin SDK y lee `userId` desde
la venta y `fcmToken` desde el usuario; no incluyas cuentas de servicio en la
app Flutter.

## 16. Probar el flujo completo

1. Ejecuta `flutter pub get`.
2. Inicia Android con `flutter run -d <device-id>`.
3. Registra un cliente y agrega un producto al carrito.
4. Completa checkout y comprueba que aparece un documento en `sales`.
5. Comprueba que `users/{uid}/bagItems` queda vacio.
6. Cierra sesion con el icono de salida.
7. Inicia como admin y comprueba que aparecen el boton `+`, la opcion de editar
   y todas las ventas en la vista `Live sales`.

Si aparece `permission-denied`, verifica en este orden:

1. Que publicaste `firestore.rules`.
2. Que el UID del documento `admins/{uid}` coincide exactamente con
   Authentication.
3. Que el usuario tiene una sesion activa.
4. Que la app apunta al mismo Project ID en el que creaste los datos.
