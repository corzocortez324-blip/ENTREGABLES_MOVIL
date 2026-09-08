import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_flutter/main.dart';

void main() {
  final casos = <String, (List<String>, String)>{
    'suma': (['2', '+', '3', '='], '5'),
    'resta negativa': (['2', '−', '3', '='], '-1'),
    'multiplicación': (['6', '×', '7', '='], '42'),
    'división': (['8', '÷', '2', '='], '4'),
    'decimal inicial y repetido': (['.', '.', '5', '+', '.', '5', '='], '1'),
    'división por cero': (['8', '÷', '0', '='], 'Error'),
    'recuperación de error': (['8', '÷', '0', '=', '+', '=', '2'], '2'),
    'igual sin operación': (['7', '='], '7'),
    'operaciones consecutivas': (['2', '+', '3', '×', '4', '='], '20'),
    'borrar negativo': (['2', '−', '3', '=', '⌫', '+', '2', '='], '2'),
    'limpiar': (['9', '+', 'C'], '0'),
  };
  for (final caso in casos.entries) {
    testWidgets(caso.key, (tester) async {
      await tester.pumpWidget(const CalculadoraApp());
      for (final tecla in caso.value.$1) {
        await tester.tap(find.widgetWithText(ElevatedButton, tecla));
        await tester.pump();
      }
      final pantalla = tester.widget<Text>(
        find.byKey(const ValueKey('pantalla')),
      );
      expect(pantalla.data, caso.value.$2);
      expect(tester.takeException(), isNull);
    });
  }
}
