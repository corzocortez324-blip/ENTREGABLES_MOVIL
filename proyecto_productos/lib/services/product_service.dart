import 'dart:convert';
import 'package:proyecto_productos/models/category.dart';
import 'package:proyecto_productos/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts({int limit = 30}) async {
    final url = Uri.parse('$_baseUrl/products?limit=$limit');

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Error Procesando Productos ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final jsonList = data['products'] as List<dynamic>;

    return jsonList
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Category>> getCategorys() async {
    final url = Uri.parse('$_baseUrl/products/categories');
    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Error Procesando Categorías ${response.statusCode}');
    }

    final jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final url = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Error Procesando Producto ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return Product.fromJson(data);
  }

  Future<List<Product>> getProductsByCategory(String slug) async {
    final url = Uri.parse('$_baseUrl/products/category/$slug');

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Error Procesando Productos ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final jsonList = data['products'] as List<dynamic>;

    return jsonList
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
