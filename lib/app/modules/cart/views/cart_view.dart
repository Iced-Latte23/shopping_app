import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/modal/product.dart';
import '../controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Obx(() {
        // Check if the cart is empty
        if (cartController.cartItems.isEmpty) {
          return _buildEmptyCartUI();
        }

        // Display the list of cart items
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  Products product = cartController.cartItems[index];
                  return Dismissible(
                    key: Key(product.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      cartController.removeFromCart(product);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: _buildCartItem(product),
                  );
                },
              ),
            ),
            // Total Price Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${cartController.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            // Checkout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (cartController.cartItems.isEmpty) {
                    Get.snackbar(
                      "Empty Cart",
                      "Your cart is empty. Add products to proceed.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    print("Proceeding to checkout...");
                    // Navigate to checkout screen
                    // Get.toNamed('/checkout');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'CHECKOUT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _StyledBottomNavigationBar(),
    );
  }

  // Build the empty cart UI
  Widget _buildEmptyCartUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 70,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Get.offNamed('/home'); // Navigate back to the home screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Shop Now",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a single cart item
  Widget _buildCartItem(Products product) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey[300]!, width: 0.5),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            product.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 30,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: () {
            cartController.removeFromCart(product);
          },
        ),
      ),
    );
  }
}

// Styled BottomNavigationBar with Gradient and Badges
class _StyledBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Obx(() {
      final cartCount = cartController.cartItems.length;

      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  Get.offNamed('/home');
                  break;
                case 1:
                  Get.offNamed('/cart');
                  break;
                case 2:
                  Get.offNamed('/favorite');
                  break;
                case 3:
                  print('profile');
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: Colors.lightBlueAccent,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: cartCount > 0
                          ? Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '$cartCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
                label: "Cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profile",
              ),
            ],
          ),
        ),
      );
    });
  }
}