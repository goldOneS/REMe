# Boletos de eventos

App móvil de venta de boletos para eventos. Flutter + Cloud Firestore + Firebase Auth (anónima).

- **Eventos**: lista en tiempo real, crear evento (formulario con validaciones).
- **Comprar**: formulario de compra; una transacción descuenta disponibilidad y registra el boleto.
- **Mis boletos**: compras del usuario/dispositivo actual.

Colecciones: `events` (name, venue, date, price, capacity, available, createdBy, createdAt) y `tickets` (eventId, eventName, buyerName, email, quantity, unitPrice, total, uid, createdAt).

## 1. Proyecto y entorno

```bash
flutter doctor
flutter create --org mx.edu.utsjr --project-name boletos_eventos --platforms=android,web .
flutter pub get
```

Elimina `test/widget_test.dart` (el generado referencia `MyApp`, que no existe aquí).

En `android/app/build.gradle(.kts)` deja `minSdk` en 23 o mayor y en `android/app/src/main/AndroidManifest.xml` agrega, antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Sin ese permiso el APK release no se conecta a Firebase.

## 2. Firebase

1. Consola Firebase → crear proyecto → **Firestore Database** (modo producción) y **Authentication → Sign-in method → Anonymous → habilitar**.
2. Firestore → **Rules** → pegar el contenido de `firestore.rules` → Publicar.
3. Conectar la app (genera `lib/firebase_options.dart` y `android/app/google-services.json`):

```bash
npm i -g firebase-tools && firebase login
dart pub global activate flutterfire_cli
flutterfire configure --platforms=android,web
```

## 3. Ejecutar

```bash
flutter run
```

## 4. Seguridad

- `lib/firebase_options.dart` y `google-services.json` están en `.gitignore`; no se suben al repositorio. Verifica con `git check-ignore -v lib/firebase_options.dart`.
- Las reglas de Firestore exigen sesión, validan tipos y longitudes, limitan la cantidad (1–10), comparan el precio contra el evento y prohíben editar o borrar boletos.
- Todos los formularios validan campos obligatorios y formatos; no se envían registros vacíos.

## 5. Control de versiones

```bash
git init && git branch -M main
git add .gitignore .metadata analysis_options.yaml pubspec.yaml pubspec.lock README.md android web && git commit -m "chore: configuración inicial del proyecto"
git add lib/models.dart lib/utils.dart lib/services && git commit -m "feat: modelos y servicio de Firestore"
git add lib/main.dart lib/screens/home_screen.dart lib/screens/events_screen.dart && git commit -m "feat: pantalla principal y lista de eventos"
git add lib/screens/event_form_screen.dart lib/screens/purchase_screen.dart && git commit -m "feat: formularios de evento y compra con validaciones"
git add lib/screens/tickets_screen.dart && git commit -m "feat: listado de boletos comprados"
git add firestore.rules && git commit -m "feat: reglas de seguridad de Firestore"
git remote add origin https://github.com/<usuario>/boletos_eventos.git
git push -u origin main
```

Después del despliegue web, sube `firebase.json` y `.firebaserc` con `git add . && git commit -m "chore: configuración de hosting" && git push`.

## 6. Compilación y distribución

**APK**

```bash
flutter build apk --release
# build/app/outputs/flutter-apk/app-release.apk
```

Instalar fuera del entorno de desarrollo: copiar el APK al teléfono, permitir instalación de orígenes desconocidos y abrirlo (o `adb install build/app/outputs/flutter-apk/app-release.apk`).

**URL del APK**: GitHub → Releases → *Draft a new release* → tag `v1.0.0` → adjuntar `app-release.apk` → Publish. El enlace de descarga del asset es la URL del instalable.

**URL de la app (web)**:

```bash
firebase init hosting      # public: build/web · SPA: yes · sobrescribir index.html: no
flutter build web --release
firebase deploy --only hosting
```

La URL queda en `https://<project-id>.web.app`.
