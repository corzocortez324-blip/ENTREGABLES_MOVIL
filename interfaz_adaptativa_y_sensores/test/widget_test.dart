import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interfaz_adaptativa_y_sensores/services/connectivity_service.dart';
import 'package:interfaz_adaptativa_y_sensores/ui/screens/home_screen.dart';
import 'package:interfaz_adaptativa_y_sensores/ui/widgets/signal_status_card.dart';

class FakeConnectivityService extends ConnectivityService {
  FakeConnectivityService(this.status);

  final SignalStatus status;

  @override
  Stream<SignalStatus> get statusStream => Stream<SignalStatus>.value(status);

  @override
  Future<SignalStatus> checkNow() async => status;
}

class FailingConnectivityService extends ConnectivityService {
  @override
  Stream<SignalStatus> get statusStream => const Stream.empty();

  @override
  Future<SignalStatus> checkNow() async =>
      throw Exception('sensor no disponible');
}

void main() {
  testWidgets('muestra un error recuperable si falla el sensor', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignalStatusCard(service: FailingConnectivityService()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No se pudo consultar la red'), findsOneWidget);
    await tester.tap(find.byTooltip('Actualizar'));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 600.0, 1024.0]) {
    testWidgets('panel sin desbordamientos a $width píxeles', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            connectivityService: FakeConnectivityService(SignalStatus.none),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Cambiar densidad'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('muestra el panel adaptativo con estado de red', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          connectivityService: FakeConnectivityService(SignalStatus.wifi),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Monitor adaptativo - Panel'), findsOneWidget);
    expect(find.text('Conexión disponible'), findsOneWidget);
    expect(find.text('Indicadores'), findsOneWidget);
  });

  testWidgets('permite navegar a ajustes y cambiar la densidad', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          connectivityService: FakeConnectivityService(SignalStatus.mobile),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(find.text('Monitor adaptativo - Ajustes'), findsOneWidget);
    expect(find.text('Vista compacta'), findsOneWidget);
  });
}
