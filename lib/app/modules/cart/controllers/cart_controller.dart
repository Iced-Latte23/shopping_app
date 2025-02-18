import 'package:final_project/app/data/modal/product.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Products>[].obs;

  void addToCart(Products product) {
    if (cartItems.contains(product)) {
      print('Product already in cart');
    } else {
      cartItems.add(product);
      print("Product added to cart: ${product.title}");
      print("Cart items: ${cartItems.map((p) => p.title).toList()}");
    }
  }

  void removeFromCart(Products product) {
    cartItems.remove(product);
    print("Product removed from cart: ${product.title}");
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, product) => sum + product.price);
  }

  void clearCart() {
    cartItems.clear();
    print("Cart cleared");
  }
}