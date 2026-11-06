# Estado del proyecto — Boletos de eventos

## Firebase configurado

- Proyecto: **Boletos de eventos** (`boletos-de-eventos`).
- Cloud Firestore Standard creado en Querétaro (`northamerica-south1`), ubicación fija.
- Firestore se inició en modo producción; las reglas reforzadas ya están publicadas.
- Authentication anónima está habilitada. La limpieza automática de cuentas quedó apagada para no borrar identidades que conservan sus boletos.
- Apps Android (`mx.edu.utsjr.boletos_eventos`) y Web registradas en Firebase.
- `.firebaserc` y `firebase.json` ya apuntan al proyecto y a `build/web`.
- `lib/firebase_options.dart` está configurado para Android y Web y permanece excluido de Git por `.gitignore`.
- Google Analytics y Gemini quedaron apagados porque no son necesarios para esta app.

## Proyecto Flutter

- Se generó el esqueleto Android y web con Flutter.
- El manifiesto Android incluye `android.permission.INTERNET`.
- `minSdk` está fijado en 23.
- Las dependencias quedaron resueltas y se generó `pubspec.lock`.
- Se quitó el test de ejemplo generado por Flutter porque no corresponde con las clases de esta app. No se ejecutaron tests.

## Reglas y alcance

- Los eventos son legibles por usuarios autenticados (incluye usuarios anónimos) y cualquier usuario de la app puede crear eventos. Es adecuado para una demo; para publicación pública, conviene limitar la creación de eventos a administradores.
- Cada persona autenticada solo puede leer sus boletos.
- Crear un boleto exige que, en la misma transacción, el stock del evento disminuya en la misma cantidad y precio. Los boletos no se pueden editar ni borrar.

## Pendiente

- El archivo `google-services.json` no se pudo descargar desde la consola; el navegador se quedó esperando en esa acción. La app usa `FirebaseOptions` explícitas en `firebase_options.dart`, por lo que ese archivo no está incluido.
- La CLI de FlutterFire no se ejecutó. La configuración local se armó con los IDs de las apps registrados en Firebase; se puede regenerar con `flutterfire configure --project=boletos-de-eventos --platforms=android,web` después de iniciar sesión en Firebase CLI.
- Ejecutar `flutter run` en Android y Web para comprobar la conexión y hacer una compra de prueba.
- Crear repositorio GitHub, hacer commits y configurar `origin`.
- Compilar APK release, publicarlo en GitHub Releases y desplegar Hosting con `firebase deploy --only hosting`.

## Verificación

Se comprobó en la consola que el proyecto, la base Firestore de Querétaro, Anonymous y las dos apps están creados. `flutter pub get` terminó correctamente. No se ejecutaron tests, análisis, compilaciones ni despliegues.
