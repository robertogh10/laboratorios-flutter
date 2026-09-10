# Seguridad de credenciales

No subas archivos `.env`, certificados, keystores, claves de firma ni cuentas
de servicio. La política está definida en `.gitignore`.

Para activar la verificación local después de clonar el repositorio, ejecuta:

```sh
git config core.hooksPath .githooks
```

El hook bloquea esos tipos de archivo y claves privadas pegadas en otro archivo.
Guarda los valores reales fuera del repositorio y comparte únicamente plantillas
con valores de ejemplo, como `.env.example`.

Las claves de API de Firebase para aplicaciones cliente no sustituyen las reglas
de Firebase: restringe cada clave en Google Cloud y mantén Firestore Storage y
Authentication protegidos con sus reglas correspondientes.
