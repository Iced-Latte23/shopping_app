import 'package:final_project/app/data/modal/product.dart';
import 'package:final_project/app/data/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductController extends GetxController {
  ProductService service = ProductService();

  var product = <Products>[].obs;
  var filterProducts = <Products>[].obs;
  var selectedCategory = RxString("");
  var searchQuery = RxString("");
  var selectedProduct = Rxn<Products>();
  TextEditingController searchController = TextEditingController();
  RxMap<int, bool> favorites = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    fetchProducts();
  }

  Future<void> loadFavorites() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in! Cannot load favorites.");
      return;
    }
    print("Loading favorites for user ID: $userId");
    try {
      // Fetch favorite product IDs from Supabase
      final response = await Supabase.instance.client
          .from('favorite')
          .select('product_id')
          .eq('user_id', userId);
      print("Raw response from Supabase: $response");

      // Map the response to a list of product IDs
      final favoriteIds = response.map((item) => item['product_id'] as int)
          .toList();
      print("Parsed favorite product IDs: $favoriteIds");

      // Clear existing favorites before populating the map
      favorites.clear();
      print("Cleared existing favorites map.");

      // Populate the reactive map with favorite product IDs
      for (var id in favoriteIds) {
        favorites[id] = true; // Mark the product as favorited
        print("Added product ID $id to favorites map.");
      }
      print("Favorites map after loading: ${favorites.entries}");
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }

  bool isFavorite(int productId) {
    return favorites[productId] ?? false;
  }

  // Toggle favorite state
  Future<void> toggleFavorite(int productId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in! $userId");
      return;
    }

    // Validate product ID
    if (productId == null || productId <= 0) {
      print("Invalid product ID: $productId");
      return;
    }

    bool updatedFavoriteState = !(favorites[productId] ?? false);
    try {
      if (updatedFavoriteState) {
        await Supabase.instance.client.from('favorite').insert({
          'user_id': userId,
          'product_id': productId,
        });
      } else {
        await Supabase.instance.client
            .from('favorite')
            .delete()
            .eq('user_id', userId)
            .eq('product_id', productId);
      }

      favorites.update(productId, (value) => updatedFavoriteState,
          ifAbsent: () => updatedFavoriteState);
      print(updatedFavoriteState
          ? "Added to favorites!"
          : "Removed from favorites!");
    } catch (e) {
      print("Error toggling favorite: $e");
      Get.snackbar(
        "Error",
        "Failed to update favorite state. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchProducts() async {
    try {
      var productList = await service.fetchProducts();
      product.assignAll(productList);
      filterProducts.assignAll(productList);
    } catch (e) {
      print('Error fetching products: $e');
      Get.snackbar('Error', 'Failed to load products. Please try again.');
    }
  }

  void applyFilters(String category, String query) {
    List<Products> filteredList = List.from(product);

    String mappedCategory = category.toLowerCase() == "headphones" ? "audio" : category;

    if (mappedCategory.isNotEmpty) {
      filteredList = filteredList
          .where(
              (item) => item.category.toLowerCase() == mappedCategory.toLowerCase())
          .toList();
    }

    if (query.isNotEmpty) {
      filteredList = filteredList
          .where(
              (item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    filterProducts.assignAll(filteredList);
  }

  // Computed property for favorite products
  List<Products> get favoriteProducts {
    if (product.isEmpty) {
      print("No products available to filter favorites.");
      return [];
    }
    return product.where((product) => favorites[product.id] ?? false).toList();
  }

  Future<List<Products>> fetchFavoriteProducts() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in! Cannot fetch favorite products.");
      return [];
    }

    try {
      // Fetch favorite product IDs from Supabase
      final response = await Supabase.instance.client
          .from('favorite')
          .select('product_id')
          .eq('user_id', userId);

      // Extract product IDs
      final favoriteIds = response.map((item) => item['product_id'] as int).toList();
      print("Favorite product IDs from Supabase: $favoriteIds");

      // Filter products based on favorite IDs
      final favoriteProducts = product.where((p) => favoriteIds.contains(p.id)).toList();
      print("Favorite products fetched: ${favoriteProducts.length}");

      return favoriteProducts;
    } catch (e, stackTrace) {
      print("Error fetching favorite products: $e");
      print("Stack trace: $stackTrace");
      return [];
    }
  }
}
