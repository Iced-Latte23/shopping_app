import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project/app/data/provider/supabase_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final RxString currentPasswordError = RxString('');
  final RxString newPasswordError = RxString('');
  final RxString confirmPasswordError = RxString('');
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  var userData = {}.obs;

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final email = SupabaseProvider.instance.supabase.auth.currentUser?.email;

      if (email == null) {
        throw Exception('User is not authenticated');
      }
      print('Fetching data for email: $email');

      final response = await SupabaseProvider.instance.fetchUser(email);
      if (response == null) {
        throw Exception('Failed to fetch user data');
      }

      userData.value = response;
    } catch (e) {
      print('Error fetching user data: $e');
      userData.value = {};
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      // Open image picker to select a new profile picture
      final pickFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickFile == null) {
        Get.snackbar("Error", "No image selected.");
        return;
      }
      File file = File(pickFile.path);

      String oldFilePath = '${userData.value['id']}_profile_pictures.png';

      SupabaseProvider.instance.deleteImage('users', oldFilePath);

      // Upload the new image
      String? imageUrl = await SupabaseProvider.instance.uploadImage(
        file,
        'users',
        oldFilePath,
      );

      if (imageUrl != null) {
        await SupabaseProvider.instance.updateUser(
          id: userData.value['id'] as int,
          img: imageUrl,
        );

        await fetchUserData();

        Get.snackbar("Success", "Profile picture updated successfully!");
      } else {
        Get.snackbar("Error", "Failed to upload profile picture.");
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      if (e.toString().contains('network')) {
        Get.snackbar(
            "Error", "A network error occurred. Please check your connection.");
      } else {
        Get.snackbar(
            "Error", "An unexpected error occurred. Please try again.");
      }
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    try {
      if (newPhoneNumber.isEmpty) {
        errorMessage.value = 'Phone number cannot be empty';
      }

      final cleanPhoneNumber = newPhoneNumber.replaceAll('-', '');

      if (!RegExp(r'^\d{9,10}$').hasMatch(cleanPhoneNumber)) {
        throw Exception('Invalid phone number format');
      }

      isLoading.value = true;

      // Update phone number in Supabase
      await SupabaseProvider.instance.updateUser(
        id: userData.value['id'],
        phone: cleanPhoneNumber,
      );

      // Fetch updated user data
      await fetchUserData();
      errorMessage.value = '';
    } catch (e) {
      // Set error message
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> updateName(String newFirstName, String newLastName) async {
    try {
      if (newFirstName.isEmpty || newLastName.isEmpty) {
        errorMessage.value = 'First name and last name cannot be empty';
      }

      isLoading.value = true;

      await SupabaseProvider.instance.updateUser(
          id: userData.value['id'],
          firstName: newFirstName,
          lastName: newLastName);

      await fetchUserData();

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    // Clear previous error messages
    errorMessage.value = '';

    // Input Validation
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      errorMessage.value = 'Please fill all the fields';
      throw Exception('Please fill all the fields');
    }
    if (newPassword != confirmPassword) {
      errorMessage.value = 'New password and confirm password do not match';
      throw Exception('New password and confirm password do not match');
    }
    if (currentPassword == newPassword) {
      errorMessage.value =
          'New password cannot be the same as the current password';
      throw Exception(
          'New password cannot be the same as the current password');
    }

    try {
      isLoading.value = true;
      final user = SupabaseProvider.instance.supabase.auth.currentUser;
      if (user == null) {
        errorMessage.value = 'User is not authenticated';
        throw Exception('User is not authenticated');
      }

      final email = user.email;
      if (email == null) {
        errorMessage.value = 'User email is not available';
        throw Exception('User email is not available');
      }

      // Verify the current password
      try {
        await SupabaseProvider.instance.supabase.auth.signInWithPassword(
          email: email,
          password: currentPassword,
        );
      } catch (e) {
        errorMessage.value = 'Current password is incorrect';
        throw Exception('Current password is incorrect');
      }

      // Update the password
      final updateResponse =
          await SupabaseProvider.instance.supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (updateResponse.user == null) {
        errorMessage.value = 'Failed to update password';
        throw Exception('Failed to update password');
      }

      // Success
      errorMessage.value = '';
      Get.dialog(
        AlertDialog(
          title: Text("Success"),
          content: Text("Password updated successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the success dialog
                Get.back(); // Close the change password dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow; // Rethrow to propagate the error to the caller
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }
}
