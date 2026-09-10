# Analisis funcional de `enyoi` y migracion

## Resumen

`enyoi` es una app didactica de Flutter que muestra Clean Architecture y varios
manejadores de estado. Su flujo ejecutable principal es autenticacion, un
dashboard sencillo, consulta de ventas, solicitud de credito, perfil y cierre de
sesion. Tambien contiene ejemplos de ecommerce y notificaciones, aunque varias
partes estan incompletas o no estan conectadas a la navegacion.

La migracion a `laboratorio_experience_app` conserva el proyecto Firebase que ya
tenia esa app. No se copiaron `google-services.json`, IDs de proyecto, API keys ni
opciones Firebase desde `enyoi`.

## Que hace `enyoi`

| Area | Como esta implementada | Estado encontrado |
|---|---|---|
| Login | Firebase Auth con email y contrasena; guarda ademas un token local simulado en SharedPreferences | Parcialmente funcional |
| Registro | Formulario con Riverpod | Simulado: no crea realmente el usuario |
| Recuperacion | Existe una pantalla visual | No esta conectada al flujo ni envia correo |
| Dashboard | Enlaces a credito, ventas, perfil y logout | La ruta de credito apunta a una ruta inexistente |
| Credito | Consulta Agify por nombre, calcula `edad * 12`, usa capacidad simulada de 60000 y aprueba 20% si puntaje > 700 | La logica existe, pero el acceso desde dashboard esta roto y depende de red |
| Ventas | Lee `sales`, ordena por `total`, ofrece stream o paginacion de dos elementos | El codigo requiere archivos generados que no estan presentes |
| Perfil | Selecciona una imagen, la sube a Firebase Storage y guarda la URL en Firestore | Usa literalmente `users/user_id`; falla para usuarios reales salvo que exista ese documento |
| Ecommerce | Lee productos desde `products` | Solo es una base: no tiene vistas/rutas y hay casos de uso sin implementar |
| Push | Solicita permiso FCM, obtiene token, muestra avisos locales y maneja taps | El token solo se imprime; no queda vinculado al usuario desde la app |
| Flavors/i18n | Entradas dev/prod y traducciones ingles/espanol | Configuracion didactica disponible |

Al validar el repositorio original, `flutter analyze` reporto 117 hallazgos,
incluidos errores por archivos Freezed/JSON ausentes. Sus 3 pruebas unitarias de
logout si pasan al ejecutar `flutter test` por separado, pero no cubren login,
Firebase, navegacion, credito, ventas, perfil, ecommerce ni notificaciones. La app
destino si pasaba analisis y sus 9 pruebas antes de la migracion.

### Hallazgos de seguridad y consistencia

- `enyoi/backend/enviar_tokens.py` contiene un token FCM real escrito en el
  codigo. Conviene eliminarlo del historial compartido y forzar su renovacion
  (por ejemplo, reinstalando la app del dispositivo afectado).
- Los scripts de venta usan `user_id`/`token`, mientras la app y su README usan
  `userId`/`fcmToken`; por ello no funcionan juntos sin modificaciones.
- Los scripts necesitan una cuenta de servicio. Esa llave nunca debe copiarse a
  Flutter ni versionarse; debe vivir unicamente en un backend confiable.

## Funcionalidades resultantes en `laboratorio_experience_app`

- Onboarding e intereses locales.
- Registro, login y logout reales con Firebase Auth.
- Recuperacion real de contrasena por correo.
- Catalogo Firestore con fallback local, detalle y variantes de producto.
- Alta/edicion de productos solo para administradores.
- Carrito y metodos de pago por usuario.
- Checkout que crea una venta y limpia el carrito.
- Stream de ventas propias; un administrador ve todas.
- Perfil del usuario con correo/nombre y foto en Firebase Storage.
- Evaluacion didactica de credito con la misma formula de `enyoi`.
- FCM en Android/iOS: permiso, notificacion local en primer plano, navegacion al
  perfil/ventas y persistencia del token en `users/{uid}`.
- Modo demo local cuando Firebase no esta configurado.

## Decisiones de migracion

- Se mantuvo la arquitectura Riverpod/Clean Architecture de la app destino.
- Las funciones incompletas de `enyoi` se implementaron de forma util en vez de
  copiar sus fallos: el registro y reset usan Firebase, el perfil usa el UID real
  y el token FCM se persiste.
- No se copio la sesion local `fake_token`: Firebase Auth ya restaura y emite el
  estado de sesion de forma segura.
- La tienda y ventas existentes son un superconjunto del ejemplo ecommerce de
  `enyoi`, por lo que se conservaron.
- La calculadora de credito conserva deliberadamente la formula de laboratorio;
  la interfaz indica que no es una evaluacion financiera real.
