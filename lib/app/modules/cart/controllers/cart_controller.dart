import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/modal/cart.dart';
import '../../../data/modal/product.dart';

class CartController extends GetxController {
  // Reactive list to store cart items
  var cartItems = <CartItem>[].obs;
  var product = <Products>[].obs;

  @override
  void onInit() {
    loadCart();
    super.onInit();
  }

  // Load cart items from Supabase
  Future<void> loadCart() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in! Cannot load cart.");
      return;
    }
    try {
      final response = await Supabase.instance.client
          .from('cart')
          .select()
          .eq('user_id', userId);
      cartItems.assignAll(
        (response as List).map((item) => CartItem.fromJson(item)).toList(),
      );
    } catch (e) {
      print("Error loading cart: $e");
    }
  }

  // Add a product to the cart
  Future<void> addToCart(
      int productId, double price, String img, String title) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in!");
      return;
    }
    try {
      // Check if the product is already in the cart
      final response = await Supabase.instance.client
          .from('cart')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId);

      if ((response as List).isNotEmpty) {
        final existingItem = response.first;
        final newQty = (existingItem['qty'] as int) + 1;

        await Supabase.instance.client
            .from('cart')
            .update({
              'qty': newQty,
            })
            .eq('user_id', userId)
            .eq('product_id', productId);
        var item = cartItems.firstWhere((item) => item.productId == productId);
        item.qty.value = newQty;
        print("Product quantity updated in cart!");
      } else {
        // Insert the product into the cart
        await Supabase.instance.client.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'title': title,
          'image': img,
          'qty': 1,
          'price': price,
        });
        print("Product added to cart!");
      }
      // Reload the cart to reflect changes
      await loadCart();
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  // Remove a product from the cart
  Future<void> removeFromCart(int productId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in!");
      return;
    }

    try {
      await Supabase.instance.client
          .from('cart')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);

      cartItems.removeWhere((item) => item.productId == productId);
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  // Update the quantity of a product in the cart
  Future<void> updateCartItemQuantity(int productId, int newQty) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in!");
      return;
    }

    try {
      await Supabase.instance.client
          .from('cart')
          .update({
            'qty': newQty,
          })
          .eq('user_id', userId)
          .eq('product_id', productId);
      var item = cartItems.firstWhere((item) => item.productId == productId);
      item.qty.value = newQty;
      print("Cart item quantity updated successfully!");
    } catch (e) {
      print("Error updating cart item quantity: $e");
    }
  }

  // Clear all items from the cart
  Future<void> clearCart() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      print("User not logged in!");
      return;
    }
    try {
      await Supabase.instance.client
          .from('cart')
          .delete()
          .eq('user_id', userId);
      cartItems.clear();
      print("Cart cleared successfully!");
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  // Calculate the total price of all items in the cart
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.qty.value));
  }
}
