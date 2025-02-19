import 'package:final_project/app/data/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../controllers/cart_controller.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> with TickerProviderStateMixin {
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());

  // Animation controller for the checkmark
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this, // Use `this` as the TickerProvider
      duration: const Duration(milliseconds: 500),
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    // Dispose the animation controller to avoid memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red[400], size: 28),
            onPressed: () {
              _showClearCartConfirmationDialog();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 50, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];
                  return Dismissible(
                    key: Key('${item.userId}-${item.productId}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => cartController.removeFromCart(item.productId),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey[300]!, width: 0.5),
                      ),
                      child: ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.image_not_supported_outlined, size: 30, color: Colors.red),
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Obx(() {
                          return Text(
                            '\$${item.price.toStringAsFixed(2)} x ${item.qty.value}',
                          );
                        }),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () {
                                if (item.qty.value > 1) {
                                  cartController.updateCartItemQuantity(item.productId, item.qty.value - 1);
                                } else {
                                  cartController.removeFromCart(item.productId);
                                }
                              },
                            ),
                            Obx(() {
                              return Text(
                                '${item.qty.value}',
                                style: TextStyle(fontSize: 16),
                              );
                            }),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () {
                                cartController.updateCartItemQuantity(item.productId, item.qty.value + 1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(() {
                    return Text(
                      '\$${cartController.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (cartController.cartItems.isEmpty) {
                    Get.snackbar(
                      "Empty Cart",
                      "Your cart is empty. Add items to proceed.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    cartController.clearCart();
                    _showCheckoutSuccessDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "CHECKOUT",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: StyledBottomNavigationBar(index: 1),
    );
  }

  // Method to show checkout success dialog
  void _showCheckoutSuccessDialog() {
    // Start the animation when the dialog is shown
    _animationController.forward();

    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      radius: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Checkmark
          ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            "Checkout Successful",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle
          Text(
            "Your order has been placed successfully!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () {
        // Close the dialog
        Get.back();

        // Optionally navigate to another screen (e.g., home)
        Get.offAllNamed('/home');
      },
    );
  }

  // Method to show clear cart confirmation dialog
  void _showClearCartConfirmationDialog() {
    Get.defaultDialog(
      title: "Clear Cart",
      middleText: "Are you sure you want to clear all items from your cart?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
      onConfirm: () {
        // Clear the cart
        cartController.clearCart();

        // Close the dialog
        Get.back();
      },
      onCancel: () {
        // Close the dialog without clearing the cart
        Get.back();
      },
    );
  }
}