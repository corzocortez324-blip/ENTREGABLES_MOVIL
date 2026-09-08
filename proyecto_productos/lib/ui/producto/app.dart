import 'package:flutter/material.dart';
import 'package:proyecto_productos/ui/producto/product_view.dart';
import 'package:proyecto_productos/ui/producto/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ejemplo Servicios',
      theme: appTheme,
      home: const ProductView(),
    );
  }
}
