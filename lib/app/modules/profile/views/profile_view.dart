import 'package:final_project/app/data/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/provider/supabase_provider.dart';
import '../../../data/utils/phone_format.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final ThemeController themeController = Get.put(ThemeController());
    controller.fetchUserData();

    return Scaffold(
      body: Obx(() {
        final userData = controller.userData.value;
        if (controller.isLoading.value == true) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
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
                                      userData['profile'].startsWith('http')
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

                      //* Profile Details
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showUpdateNameDialog(controller);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'
                                        .trim() == ''
                                        ? 'Unknown User'
                                        : 'Hello, ${userData['first_name']} ${userData['last_name']}',
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
                                  Tooltip(
                                    message: 'Edit Name',
                                    child: IconButton(
                                      onPressed: () {
                                        _showUpdateNameDialog(controller);
                                      },
                                      icon: Icon(Icons.edit, color: Colors.grey, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                _buildActionButton(Icons.shopping_cart, 'My Orders', Colors.blue, () {
                                  Get.offNamed('/cart');
                                }),
                                SizedBox(width: 10),
                                _buildActionButton(Icons.favorite, 'Wishlist', Colors.red, () {
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

              //* Profile Details Section (Card Layout)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AnimatedContainer(
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
                            Divider(),
                            SizedBox(height: 10),
                            _buildContactInfo(
                                Icons.email, userData['email'] ?? 'No email'),
                            SizedBox(height: 10),
                            _buildContactInfo(
                              Icons.phone,
                              _formatPhoneNumber(
                                  userData['phone'] ?? 'No phone number'),
                              onEdit: () => _showUpdatePhoneDialog(controller),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 45),

                    //* Settings Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('Notifications'),
                          trailing: Switch(
                            value: true,
                            onChanged: (value) {
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
                            _showChangePasswordDialog(controller);
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

  //? build contact info rows
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

  //? Show dialog to update phone number
  void _showUpdatePhoneDialog(ProfileController controller) {
    final TextEditingController phoneController = TextEditingController();

    Get.defaultDialog(
      title: 'Update Phone Number',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      content: Obx(() {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for Phone Number
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  PhoneNumberFormatter(maxDigits: 10),
                ],
                decoration: InputDecoration(
                  labelText: 'New Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorText: controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : null,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.grey),
                  suffixIcon: controller.errorMessage.value.isNotEmpty
                      ? Icon(Icons.error_outline, color: Colors.red)
                      : null,
                ),
              ),
              SizedBox(height: 24),

              //* Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.errorMessage.value = ''; // Clear error message
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  //* Save Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                        final newPhoneNumber = phoneController.text.trim();

                        // Call the updatePhoneNumber function
                        await controller.updatePhoneNumber(newPhoneNumber);

                        // Close the dialog if there's no error
                        if (controller.errorMessage.value.isEmpty) {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 51),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  //? Show dialog to update name
  void _showUpdateNameDialog(ProfileController controller) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    Get.defaultDialog(
      title: 'Update Name',
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      content: Obx(() {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* TextField for First Name
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorText: controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : null,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),

              //* TextField for Last Name
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorText: controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : null,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),
              ),
              SizedBox(height: 24),

              //* Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.errorMessage.value = ''; // Clear error message
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  //* Save Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                        final firstName = firstNameController.text.trim();
                        final lastName = lastNameController.text.trim();

                        // Call the updateName function
                        await controller.updateName(firstName, lastName);

                        // Close the dialog if there's no error
                        if (controller.errorMessage.value.isEmpty) {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 51),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  //? Format phone numbers with hyphens
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

  //? build action buttons (e.g., My Orders, Wishlist)
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

  //? Show dialog to update password
  void _showChangePasswordDialog(ProfileController controller) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    final RxBool isCurrentPasswordVisible = false.obs;
    final RxBool isNewPasswordVisible = false.obs;
    final RxBool isConfirmPasswordVisible = false.obs;

    Get.defaultDialog(
      title: 'Change Password',
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      content: SingleChildScrollView(
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display error message if any
              if (controller.errorMessage.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red[50], // Light red background for error message
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center, // Center-align the error message
                  ),
                ),
              SizedBox(height: 12),

              //* TextField for Current Password
              TextField(
                controller: currentPasswordController,
                obscureText: !isCurrentPasswordVisible.value,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.errorMessage.value = '';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isCurrentPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      isCurrentPasswordVisible.toggle();
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),

              //* TextField for New Password
              TextField(
                controller: newPasswordController,
                obscureText: !isNewPasswordVisible.value,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.errorMessage.value = '';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isNewPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      isNewPasswordVisible.toggle();
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),

              //* TextField for Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible.value,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.errorMessage.value = '';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      isConfirmPasswordVisible.toggle();
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),

              //* Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.errorMessage.value = '';
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  //* Save Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                        final String currentPassword = currentPasswordController.text.trim();
                        final String newPassword = newPasswordController.text.trim();
                        final String confirmPassword = confirmPasswordController.text.trim();

                        try {
                          await controller.changePassword(
                            currentPassword: currentPassword,
                            newPassword: newPassword,
                            confirmPassword: confirmPassword,
                          );
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 51),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
