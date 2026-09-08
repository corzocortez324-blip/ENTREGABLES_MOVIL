import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:temu_static_clone/main.dart';

void main() {
  for (final size in [const Size(360, 800), const Size(1200, 600)]) {
    testWidgets('conserva la proporción en $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const StaticCloneApp());
      await tester.pumpAndSettle();
      final rendered = tester.getSize(find.byType(AspectRatio));
      expect(rendered.width / rendered.height, closeTo(709 / 1600, 0.001));
      expect(rendered.width, lessThanOrEqualTo(size.width));
      expect(rendered.height, lessThanOrEqualTo(size.height));
      expect(tester.takeException(), isNull);
    });
  }
}
