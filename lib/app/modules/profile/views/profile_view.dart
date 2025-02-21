import 'dart:io';
import 'package:final_project/app/data/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/controller/product_controller.dart';
import '../../../data/provider/supabase_provider.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView {
  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final ProfileController controller = Get.put(ProfileController());
    final ThemeController themeController = Get.put(ThemeController());
    controller.fetchUserData(); // Fetch user data when the widget is built

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: Obx(() {
        // Use Obx to reactively update the UI when userData changes
        final userData = controller.userData.value;
        if (controller.isLoading.value == true) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // Gradient Header Section with Custom Shape
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[800]!, Colors.blueGrey[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () async {
                          await controller.updateProfilePicture();
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
                          child: Obx(() {
                            final userData = controller.userData.value;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              child: userData['profile'] != null &&
                                      userData['profile']
                                          .startsWith('http')
                                  ? Image.network(
                                      userData['profile'],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/default_profile.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            );
                          }),
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
                                  Get.offNamed('/favorite');
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
                                  'User Information',
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
                                _buildContactInfo(
                                  Icons.phone,
                                  _formatPhoneNumber(
                                      userData['phone'] ?? 'No phone number'),
                                  onEdit: () =>
                                      _showUpdatePhoneDialog(controller),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 35),

                    // Settings Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Notifications'),
                          trailing: Switch(
                            value: true,
                            // Replace with actual notification preference
                            onChanged: (value) {
                              // Update notification preference
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.brightness_4),
                          title: Text('Dark Mode'),
                          trailing: Switch(
                            value: themeController.isDarkMode.value,
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.security),
                          title: Text('Change Password'),
                          onTap: () {
                            // Navigate to change password screen
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Delete Account'),
                          onTap: () {
                            // Show confirmation dialog to delete account
                          },
                        ),
                      ],
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
  Widget _buildContactInfo(IconData icon, String text, {VoidCallback? onEdit}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit, size: 18, color: Colors.grey),
            onPressed: onEdit,
          ),
      ],
    );
  }

  // Show dialog to update phone number
  void _showUpdatePhoneDialog(ProfileController controller) {
    final TextEditingController phoneController = TextEditingController();

    Get.defaultDialog(
      title: 'Update Phone Number',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'New Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final newPhoneNumber = phoneController.text.trim();
              if (newPhoneNumber.isNotEmpty) {
                try {
                  await SupabaseProvider.instance.updateUser(
                    id: controller.userData.value['id'],
                    // phone: newPhoneNumber,
                  );
                  Get.back(); // Close the dialog
                  Get.snackbar('Success', 'Phone number updated successfully!');
                  controller.fetchUserData(); // Refresh the UI
                } catch (e) {
                  Get.snackbar('Error', 'Failed to update phone number');
                }
              } else {
                Get.snackbar('Error', 'Phone number cannot be empty');
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Helper method to format phone numbers with hyphens
  String _formatPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'No phone number';
    }

    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check the length of the phone number
    if (digitsOnly.length == 9) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6, 9)}';
    } else if (digitsOnly.length == 10) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6, 10)}';
    } else {
      return phoneNumber;
    }
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
          children: [
            Icon(icon, size: 14, color: color),
            SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                style: TextStyle(fontSize: 12, color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
