import 'package:get/get.dart';

class CartItem {
  String userId;
  int productId;
  var qty= 0.obs;
  double price;
  String title; // Product title
  String image; // Product image URL

  CartItem({
    required this.userId,
    required this.productId,
    required int qty,
    required this.price,
    required this.title,
    required this.image,
  }) {
    this.qty.value = qty;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      userId: json['user_id'],
      productId: json['product_id'],
      qty: json['qty'],
      price: json['price']?.toDouble() ?? 0.0,
      title: json['title'] ?? 'Unknown Product',
      image: json['image'],
    );
  }
}