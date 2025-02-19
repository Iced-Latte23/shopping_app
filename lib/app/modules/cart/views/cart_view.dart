import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 50, color: Colors.grey),
                const SizedBox(height: 16),
                Text("Your cart is empty",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
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
                    // Composite key as unique identifier
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) =>
                        cartController.removeFromCart(item.productId),
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
                                    child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 30,
                                        color: Colors.red));
                              },
                            ),
                          ),
                        ),
                        title: Text(item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Obx(() {
                          return Text(
                              '\$${item.price.toStringAsFixed(2)} x ${item.qty.value}');
                        }),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () {
                                if (item.qty.value > 1) {
                                  cartController.updateCartItemQuantity(
                                      item.productId, item.qty.value - 1);
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
                              icon: Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                              onPressed: () {
                                cartController.updateCartItemQuantity(
                                    item.productId, item.qty.value + 1);
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Obx(() {
                    return Text(
                        '\$${cartController.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green));
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  print("Proceeding to checkout...");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("CHECKOUT",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2)),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _StyledBottomNavigationBar(),
    );
  }
}

class _StyledBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    child: Container(
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
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
  }
}
