import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductView extends ConsumerWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Productos')),
      body: const Column(
        children: [MisCategorias(), Divider(height: 2), MisProductos()],
      ),
    );
  }
}

class MisProductos extends StatelessWidget {
  const MisProductos({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const IconosCategorias(),
            title: Text('Producto #$index'),
            subtitle: const Text('Mensaje.....'),
          );
        },
      ),
    );
  }
}

class MisCategorias extends StatelessWidget {
  const MisCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        IconosCategorias(),
        IconosCategorias(),
        IconosCategorias(),
      ],
    );
  }
}

class IconosCategorias extends StatelessWidget {
  const IconosCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(radius: 30, child: Icon(Icons.card_travel)),
    );
  }
}
