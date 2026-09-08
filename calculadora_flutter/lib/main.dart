import 'package:flutter/material.dart';

void main() => runApp(const CalculadoraApp());

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Calculadora',
    home: Calculadora(),
  );
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});
  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String pantalla = '0';
  double primerNumero = 0;
  String operacion = '';
  bool nuevoNumero = true;

  void _limpiar() {
    pantalla = '0';
    primerNumero = 0;
    operacion = '';
    nuevoNumero = true;
  }

  void _resolver() {
    final segundo = double.tryParse(pantalla);
    if (segundo == null || operacion.isEmpty) return;
    final resultado = switch (operacion) {
      '+' => primerNumero + segundo,
      '−' => primerNumero - segundo,
      '×' => primerNumero * segundo,
      '÷' => primerNumero / segundo,
      _ => segundo,
    };
    pantalla = resultado.isFinite ? resultado.toString() : 'Error';
    if (pantalla.endsWith('.0')) {
      pantalla = pantalla.substring(0, pantalla.length - 2);
    }
    operacion = '';
    nuevoNumero = true;
  }

  void _pulsar(String texto) {
    setState(() {
      if (texto == 'C') {
        _limpiar();
      } else if (texto == '⌫') {
        if (pantalla == 'Error' || nuevoNumero) {
          _limpiar();
        } else {
          pantalla = pantalla.length > 1
              ? pantalla.substring(0, pantalla.length - 1)
              : '0';
          if (double.tryParse(pantalla) == null) pantalla = '0';
        }
      } else if (['+', '−', '×', '÷'].contains(texto)) {
        if (pantalla == 'Error') return;
        if (operacion.isNotEmpty && !nuevoNumero) _resolver();
        final numero = double.tryParse(pantalla);
        if (numero == null) return;
        primerNumero = numero;
        operacion = texto;
        nuevoNumero = true;
      } else if (texto == '=') {
        if (!nuevoNumero) _resolver();
      } else {
        if (nuevoNumero) {
          pantalla = texto == '.' ? '0.' : texto;
          nuevoNumero = false;
        } else if (texto == '.') {
          if (!pantalla.contains('.')) pantalla += '.';
        } else {
          pantalla = pantalla == '0' ? texto : pantalla + texto;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Calculadora')),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  pantalla,
                  key: const ValueKey('pantalla'),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: LayoutBuilder(
              builder: (context, constraints) => GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: ((constraints.maxHeight - 60) / 5).clamp(
                  48.0,
                  100.0,
                ),
                children: [
                  for (final texto in [
                    'C',
                    '÷',
                    '×',
                    '⌫',
                    '7',
                    '8',
                    '9',
                    '−',
                    '4',
                    '5',
                    '6',
                    '+',
                    '1',
                    '2',
                    '3',
                    '=',
                    '0',
                    '.',
                  ])
                    ElevatedButton(
                      onPressed: () => _pulsar(texto),
                      child: Text(texto, style: const TextStyle(fontSize: 24)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
