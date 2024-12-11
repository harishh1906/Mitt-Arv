import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHelper {
  static const String baseUrl = 'https://fakestoreapi.com';

  static Future<List<dynamic>> fetchProducts([int limit = 10]) async {
    final response = await http.get(Uri.parse('$baseUrl/products?limit=$limit'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
