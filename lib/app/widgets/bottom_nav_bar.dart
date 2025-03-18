import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/cart/controllers/cart_controller.dart';

class StyledBottomNavigationBar extends StatelessWidget {
  StyledBottomNavigationBar({required this.index, super.key});
  int index;

  final CartController cartController = Get.put(CartController());
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
          currentIndex: index,
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
                Get.offNamed('/profile');
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
                    child: Obx(() {
                      final cartItemCount = cartController.cartItems.fold<int>(0, (sum, item) => sum + item.qty.value);

                      if (cartItemCount == 0) {
                        return Container(); // Return an empty container if the count is 0
                      }

                      return Container(
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
                          cartItemCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
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