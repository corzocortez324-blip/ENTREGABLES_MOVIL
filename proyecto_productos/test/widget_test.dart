import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_productos/ui/producto/app.dart';

void main() {
  testWidgets('muestra la pantalla principal de productos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Mis Productos'), findsOneWidget);
    expect(find.text('Producto #0'), findsOneWidget);
    expect(find.text('Mensaje.....'), findsWidgets);
  });
}
