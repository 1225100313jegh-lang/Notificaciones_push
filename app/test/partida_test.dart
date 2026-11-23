import 'package:flutter_test/flutter_test.dart';
import 'package:loteria_push/dominio/evento.dart';
import 'package:loteria_push/dominio/partida.dart';

import 'falsos.dart';

void main() {
  Partida nueva() => Partida(
        sala: 'ABCDE',
        nombre: 'Ana',
        tabla: List.generate(16, (i) => i + 1),
      );

  test('aplica las cartas en orden y conserva la última', () {
    final p = nueva();
    expect(p.aplicar(carta(1, 10)), ResultadoAplicar.aplicado);
    expect(p.aplicar(carta(2, 11)), ResultadoAplicar.aplicado);
    expect(p.ultima, 2);
    expect(p.ultimaCarta!.cartaId, 11);
  });

  test('ignora un push duplicado', () {
    final p = nueva();
    p.aplicar(carta(1, 10));
    expect(p.aplicar(carta(1, 10)), ResultadoAplicar.duplicado);
    expect(p.ultima, 1);
  });

  test('detecta un hueco y no aplica la carta adelantada', () {
    final p = nueva();
    p.aplicar(carta(1, 10));
    expect(p.aplicar(carta(3, 12)), ResultadoAplicar.hueco);
    expect(p.ultima, 1);
  });

  test('aplicarLote ordena las cartas y elimina repetidas', () {
    final p = nueva();
    p.aplicarLote([carta(4, 13), carta(2, 11), carta(3, 12), carta(2, 11), carta(1, 10)]);
    expect(p.cantadas.map((c) => c.n), [1, 2, 3, 4]);
  });

  test('aplicarLote se detiene al encontrar el primer hueco', () {
    final p = nueva();
    p.aplicarLote([carta(1, 10), carta(2, 11), carta(4, 13)]);
    expect(p.ultima, 2);
  });

  test('marca solo las cartas que están en la tabla del jugador', () {
    final p = nueva();
    p.aplicar(carta(1, 3));
    p.aplicar(carta(2, 40));
    expect(p.estaMarcada(3), isTrue);
    expect(p.estaMarcada(5), isFalse);
    expect(p.tabla.where(p.estaMarcada).toList(), [3]);
  });

  test('habilita Lotería al completar un patrón', () {
    final p = nueva();
    for (var i = 1; i <= 3; i++) {
      p.aplicar(carta(i, i));
    }
    expect(p.puedeCantarLoteria, isFalse);
    p.aplicar(carta(4, 4));
    expect(p.puedeCantarLoteria, isTrue);
    expect(p.patrones, ['fila1']);
  });

  test('registra al ganador y deshabilita Lotería', () {
    final p = nueva();
    for (var i = 1; i <= 4; i++) {
      p.aplicar(carta(i, i));
    }
    p.aplicar(const LoteriaCantada(n: 4, ganador: 'Beto', patron: 'fila2'));
    expect(p.ganador, 'Beto');
    expect(p.puedeCantarLoteria, isFalse);
  });

  test('trata el aviso de Lotería repetido como duplicado', () {
    final p = nueva();
    const evento = LoteriaCantada(n: 4, ganador: 'Beto', patron: 'fila2');
    expect(p.aplicar(evento), ResultadoAplicar.aplicado);
    expect(p.aplicar(evento), ResultadoAplicar.duplicado);
  });

  test('un aviso de casi solo informa', () {
    final p = nueva();
    expect(p.aplicar(const CasiGanas(n: 3, cartaId: 7)), ResultadoAplicar.informativo);
    expect(p.casi, isTrue);
    expect(p.cartaQueFalta, 7);
  });
}
