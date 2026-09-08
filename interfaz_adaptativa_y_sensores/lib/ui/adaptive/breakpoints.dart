import 'package:flutter/material.dart';

/// Tamaños de pantalla que reconoce la interfaz adaptativa.
enum ScreenSize { mobile, tablet, desktop }

class Breakpoints {
  Breakpoints._();

  static const double tablet = 600;
  static const double desktop = 1024;

  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return fromWidth(width);
  }

  static ScreenSize fromWidth(double width) {
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}
