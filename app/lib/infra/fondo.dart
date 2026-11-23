import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Inicializa Firebase en el isolate que procesa los push con la app cerrada.
@pragma('vm:entry-point')
Future<void> manejadorSegundoPlano(RemoteMessage message) async {
  await Firebase.initializeApp();
}
