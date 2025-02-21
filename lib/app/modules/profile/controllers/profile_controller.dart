import 'dart:io';

import 'package:get/get.dart';
import 'package:final_project/app/data/provider/supabase_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var userData = {}.obs;
  var isLoading = true.obs;

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final email = SupabaseProvider.instance.supabase.auth.currentUser?.email;

      if (email == null) {
        throw Exception('User is not authenticated');
      }
      print('Fetching data for email: $email'); // Debug log

      final response = await SupabaseProvider.instance.fetchUser(email);
      if (response == null) {
        throw Exception('Failed to fetch user data');
      }

      userData.value = response;
    } catch (e) {
      print('Error fetching user data: $e');
      userData.value = {};
    } finally {
      isLoading.value = false; // Ensure loading state is reset
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      // Open image picker to select a new profile picture
      final pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
        Get.snackbar("Error", "A network error occurred. Please check your connection.");
      } else {
        Get.snackbar("Error", "An unexpected error occurred. Please try again.");
      }
    }
  }
}
