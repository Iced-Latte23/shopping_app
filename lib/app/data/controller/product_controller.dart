import 'package:final_project/app/data/modal/product.dart';
import 'package:final_project/app/data/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductService service = ProductService();

  var product = <Products>[].obs;
  var filterProducts = <Products>[].obs;
  var selectedCategory = RxString("");
  var searchQuery = RxString("");
  var selectedProduct = Rxn<Products>();
  TextEditingController searchController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch products from the API
  Future<void> fetchProducts() async {
    try {
      var productList = await service.fetchProducts();
      product.assignAll(productList);
      filterProducts.assignAll(productList);
    } catch (e) {
      print('Error fetching products: $e');
      // Optionally, show a snackbar to notify the user
      Get.snackbar('Error', 'Failed to load products. Please try again.');
    }
  }

  void setSelectedProduct(Products product) {
    selectedProduct.value = product;
  }

// Filter products by category and search query
  void applyFilters(String category, String query) {
    List<Products> filteredList = product;
    // Step 1: Filter by category
    if (category.isNotEmpty) {
      filteredList =
          filteredList.where((item) => item.category == category).toList();
    }
    // Step 2: Filter by search query
    if (query.isNotEmpty) {
      filteredList = filteredList.where((item) =>
          item.title.toLowerCase().contains(query.toLowerCase())).toList();
    }
    // Update the filtered product list
    filterProducts.assignAll(filteredList);
  }
}
