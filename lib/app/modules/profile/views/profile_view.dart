import 'package:final_project/app/data/controller/product_controller.dart';
import 'package:final_project/app/data/provider/supabase_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
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
                      colors: [Colors.blue, Colors.purple],
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
                    SizedBox(width: 30),
                    // Profile Picture with Shadow and Animation
                    GestureDetector(
                      onTap: () {
                        // Add functionality for profile picture tap (e.g., open image picker)
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.asset(
                            'assets/images/profile.jpg', // Replace with your image path
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
                            'Hour Panha',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Flutter Developer',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // Social Buttons
                          Row(
                            children: [
                              _buildSocialButton(Icons.email, 'Message', Colors.blue),
                              SizedBox(width: 10),
                              _buildSocialButton(Icons.call, 'Call', Colors.green),
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
                  // About Me Card with Gradient Border
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.withOpacity(0.5), Colors.purple.withOpacity(0.5)],
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
                              'About Me',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'I am a passionate Flutter developer with experience in building mobile applications. I love creating user-friendly and efficient apps.',
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

                  // Contact Information Card with Hover Effect
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {},
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
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
                              _buildContactInfo(Icons.email, 'johndoe@example.com'),
                              SizedBox(height: 10),
                              _buildContactInfo(Icons.phone, '+1 234 567 890'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add logout functionality here
                      Get.defaultDialog(
                        title: 'Logout',
                        middleText: 'Are you sure you want to logout?',
                        textConfirm: 'Yes',
                        textCancel: 'No',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.black,
                        buttonColor: Colors.red,
                        onConfirm: () {
                          // Perform logout logic here
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      ),
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

  // Helper method to build social buttons
  Widget _buildSocialButton(IconData icon, String text, Color color) {
    return InkWell(
      onTap: () {
        // Add functionality for button tap
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(fontSize: 14, color: color),
            ),
          ],
        ),
      ),
    );
  }
}