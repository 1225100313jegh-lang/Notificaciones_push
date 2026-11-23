import 'package:flutter_test/flutter_test.dart';

import 'falsos.dart';

void main() {
  test('el helper crea cartas de prueba con su número e id', () {
    final evento = carta(3, 42);
    expect(evento.n, 3);
    expect(evento.cartaId, 42);
    expect(evento.nombre, 'Carta 42');
  });
}
