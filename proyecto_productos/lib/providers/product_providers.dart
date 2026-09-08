import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_productos/models/category.dart';
import 'package:proyecto_productos/models/product.dart';
import 'package:proyecto_productos/services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.watch(productServiceProvider);
  return service.getCategorys();
});

class CategoriaSeleccionada extends Notifier<String?> {
  @override
  String? build() => null;

  void selecionar(String? slug) {
    state = (state == slug) ? null : slug;
  }
}

final categoriaSeleccionadaProvider =
    NotifierProvider<CategoriaSeleccionada, String?>(CategoriaSeleccionada.new);

final productProvider = FutureProvider<List<Product>>((ref) async {
  final service = ref.watch(productServiceProvider);
  final slug = ref.watch(categoriaSeleccionadaProvider);
  return (slug == null)
      ? service.getProducts()
      : service.getProductsByCategory(slug);
});

final productByProvider = FutureProvider.family<Product, int>((ref, id) async {
  final service = ref.watch(productServiceProvider);
  return service.getProductById(id);
});
