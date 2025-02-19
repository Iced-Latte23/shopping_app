import 'dart:convert';

import 'package:final_project/app/data/modal/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String getProductUrl = "https://fakestoreapi.in/api/products";

  Future<List<Products>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(getProductUrl));
      if (response.statusCode == 200) {

        // print('API Response: ${response.body}');

        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> productsJson = jsonResponse['products'];
        return productsJson.map((item) => Products.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}