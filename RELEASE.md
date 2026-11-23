# APK para uso personal

El APK se firma con la clave de depuración local de Android. Es adecuado para instalarlo manualmente en tus propios teléfonos. Si borras esa clave, una versión posterior no podrá actualizar la instalada: tendrás que desinstalar la app y volver a instalarla.

## Firebase

1. En Firebase Console, abre el proyecto Android con el identificador `com.loteriapush.app` y descarga `google-services.json`.
2. Coloca ese archivo en `app/android/app/google-services.json`. No uses el JSON de cuenta de servicio del servidor en esta ubicación: contiene una clave privada y nunca debe entrar en la app.
3. En el servidor, configura `GOOGLE_APPLICATION_CREDENTIALS` para que apunte al JSON de cuenta de servicio y ejecuta con `FCM_REAL=1`.

## Compilar

En PowerShell, desde la carpeta `app`:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build apk --release --dart-define=SERVIDOR=https://TU-DOMINIO
```

El archivo queda en `app/build/app/outputs/flutter-apk/app-release.apk`. Para probar en la misma red Wi-Fi con un servidor local, usa `--dart-define=SERVIDOR=http://IP-DE-TU-PC:8080`; inicia el servidor escuchando en esa interfaz y permite el puerto 8080 en el firewall. El valor por defecto `10.0.2.2` sirve solo para el emulador Android.

## Instalar en el móvil

1. Copia `app-release.apk` al teléfono (USB, Drive o un mensaje privado).
2. Abre el APK y permite temporalmente instalar aplicaciones desde esa fuente si Android lo solicita.
3. Abre Lotería Push. Concede permiso de notificaciones cuando quieras recibir cartas con la app cerrada; si lo rechazas, la app consulta el servidor mientras permanece abierta.
4. Para jugar, el teléfono y el cantor deben usar el mismo servidor. El cantor crea la sala y comparte su código; los jugadores introducen ese código.

Para actualizar conservando la app, genera las versiones en el mismo Windows con el mismo usuario y no borres la clave de depuración de Android (`%USERPROFILE%\.android\debug.keystore`).
