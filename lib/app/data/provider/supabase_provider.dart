import 'dart:io';

import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_pages.dart';

class SupabaseProvider {
  static SupabaseProvider instance = SupabaseProvider._privateConstructor();

  SupabaseProvider._privateConstructor();

  final supabase = Supabase.instance.client;

  Future<bool> addUser(
      {required String firstName,
      required String lastName,
      required String email,
      String? img}) async {
    try {
      final response = await supabase.from('users').insert({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'profile': img ?? "", // If img is null, set it to an empty string
      });

      // Debugging: Check the full response
      print('---- Full response: $response');

      // Check if there was an error in the response
      if (response.error != null) {
        print('Error adding user: ${response.error!.message}');
        return false; // Return false if there's an error
      }

// If there's no error, return true to indicate success
      return true;
    } catch (e) {
      // Catch any unexpected errors and log them
      print('---- Error adding user: $e');
      return false;
    }
  }

  Future<String?> uploadImage(File file, String bucket, String path) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final bytes = await file.readAsBytes();

      final response = await supabase.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: mimeType),
          );
      if (response.error != null) {
        Get.snackbar(
            "Error", "Failed to upload image: ${response.error?.message}");
        return null;
      }
      final publicUrl = supabase.storage.from(bucket).getPublicUrl(path);
      print("----- Uploaded Image URL: $publicUrl");
      return publicUrl;
    } catch (e) {
      Get.snackbar("Error", "Image upload failed: $e");
      print("----- Image upload failed: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateUser(
      {required String id,
      String? firstName,
      String? lastName,
      String? email,
      String? img}) async {
    try {
      // Create a map of fields to update (only non-null values are included)
      final Map<String, dynamic> updateData = {};
      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (email != null) updateData['email'] = email;
      if (img != null) updateData['profile'] = img;

      // If no fields are provided to update, return null
      if (updateData.isEmpty) {
        print('----- No fields provided to update.');
        return null;
      }

      // Perform the update operation
      final response =
          await supabase.from('users').update(updateData).eq('id', id);

      if (response.error != null) {
        throw Exception('Failed to update user: ${response.error!.message}');
      }

      // Assuming the response contains the updated data
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print('----- Error updating user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUser(String email) async {
    try {
      final response =
          await supabase.from('users').select().eq('email', email).single();

      if (response == null) {
        print('No user found with email: $email');
        return null;
      }

      return response;
    } catch (e) {
      print('----- Error fetching user: $e');
      return null;
    }
  }

  Future<bool> loginWithEmail(
      {required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session != null;
    } catch (e) {
      Get.snackbar("Error", 'Error ${e.toString()}');
      return false;
    }
  }

  Future<bool> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password);
      return response.user != null;
    } catch (e) {
      print('----- Sign-up error: $e');
      return false;
    }
  }

  Future<bool> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    return user != null;
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('----- Error signing out: $e');
      throw Exception('Failed to sign out: $e');
    }
  }
}

extension on PostgrestMap {
  get error => null;
}

extension on String {
  get error => null;
}
