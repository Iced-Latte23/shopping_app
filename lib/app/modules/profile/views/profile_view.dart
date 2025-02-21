import 'package:final_project/app/data/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/provider/supabase_provider.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final ProfileController controller = Get.put(ProfileController());
    controller.fetchUserData();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        // Use Obx to reactively update the UI when userData changes
        final userData = controller.userData.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Gradient Header Section with Custom Shape
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[800]!, Colors.blueGrey[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    child: ClipPath(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      // Profile Picture with Shadow and Animation
                      GestureDetector(
                        onTap: () {
                          // Add functionality for profile picture tap (e.g., open image picker)
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: userData['profilePicture'] != null &&
                                    userData['profilePicture']
                                        .startsWith('http')
                                ? Image.network(
                                    userData['profilePicture'],
                                    // Remote profile picture URL
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/default_profile.jpg',
                                    // Local default placeholder
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Profile Details
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'
                                          .trim() ==
                                      ''
                                  ? 'Unknown User'
                                  : '${userData['first_name']} ${userData['last_name']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(2, 2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              userData['email'] ?? 'No email',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            // Social Buttons
                            Row(
                              children: [
                                _buildActionButton(Icons.shopping_cart,
                                    'My Orders', Colors.blue, () {
                                  // Navigate to order history
                                }),
                                SizedBox(width: 10),
                                _buildActionButton(
                                    Icons.favorite, 'Wishlist', Colors.red, () {
                                  // Navigate to wishlist
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Profile Details Section (Card Layout)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Contact Information Card with Hover Effect
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildContactInfo(Icons.email,
                                    userData['email'] ?? 'No email'),
                                SizedBox(height: 10),
                                _buildContactInfo(Icons.phone,
                                    userData['phone'] ?? 'No phone number'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Address Section
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.5),
                            Colors.purple.withOpacity(0.5)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saved Addresses',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                userData['address'] ?? 'No saved address',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Logout Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Logout',
                          middleText: 'Are you sure you want to logout?',
                          textConfirm: 'Yes',
                          textCancel: 'No',
                          confirmTextColor: Colors.white,
                          cancelTextColor: Colors.black,
                          buttonColor: Colors.red,
                          onConfirm: () {
                            print('User logged out');
                            SupabaseProvider.instance.signOut();
                          },
                          onCancel: () {
                            Get.back(); // Close dialog
                          },
                        );
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: StyledBottomNavigationBar(index: 3),
    );
  }

  // Helper method to build contact info rows
  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  // Helper method to build action buttons (e.g., My Orders, Wishlist)
  Widget _buildActionButton(
      IconData icon, String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // Ensures the Row takes only as much space as needed
          children: [
            Icon(icon, size: 14, color: color),
            SizedBox(width: 5),
            Flexible(
              // Wrap the Text widget with Flexible to prevent overflow
              child: Text(
                text,
                style: TextStyle(fontSize: 12, color: color),
                overflow: TextOverflow.ellipsis, // Add ellipsis for long text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
