import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_pages.dart';

class SupabaseProvider {
  static final SupabaseProvider instance = SupabaseProvider._privateConstructor();

  SupabaseProvider._privateConstructor();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> addUser({required String firstName, required String lastName, required String email, String? img}) async {
    try {
      final response = await supabase.from('users').insert({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'profile': img ?? "",
      });

      if (response.error != null) {
        debugPrint('Error adding user: ${response.error!.message}');
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('---- Error adding user: $e');
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
      debugPrint("----- Uploaded Image URL: $publicUrl");
      return publicUrl;
    } catch (e) {
      Get.snackbar("Error", "Image upload failed: $e");
      debugPrint("----- Image upload failed: $e");
      return null;
    }
  }

  Future<void> deleteImage(String bucketName, String filePath) async {
    try {
      await supabase.storage.from(bucketName).remove([filePath]);
      debugPrint('Deleted old image: $filePath');
    } catch (e) {
      debugPrint('----- Error deleting old image: $e');
    }
  }

  Future<Map<String, dynamic>?> updateUser({required int id, String? firstName, String? lastName, String? email,String? phone,String? img}) async {
    try {
      final Map<String, dynamic> updateData = {};
      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['phone'] = phone;
      if (img != null) updateData['profile'] = img;

      if (updateData.isEmpty) {
        debugPrint('----- No fields provided to update.');
        return null;
      }

      final response = await supabase.from('users').update(updateData).eq('id', id);

      if (response.error != null) {
        debugPrint('Failed to update user: ${response.error!.message}');
      }

      // Assuming the response contains the updated data
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('----- Error updating user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUser(String email) async {
    try {
      final response = await supabase.from('users').select().eq('email', email).single();

      if (response == null) {
        debugPrint('No user found with email: $email');
        return null;
      }

      return response;
    } catch (e) {
      debugPrint('----- Error fetching user: $e');
      return null;
    }
  }

  Future<bool> loginWithPassword({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.session != null;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }

  Future<bool> signUpWithEmail({required String email, required String password}) async {
    try {
      final response = await supabase.auth.signUp(email: email, password: password);
      return response.user != null;
    } catch (e) {
      debugPrint('----- Sign-up error: $e');
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
      debugPrint('----- Error signing out: $e');
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<Session?> getCurrentSession() async {
    try {
      final session = await supabase.auth.currentSession;
      return session;
    } catch (e) {
      debugPrint('----- Error getting current session: $e');
      return null;
    }
  }

  // Future<bool> changePassword(String newPassword) async {
  //   try {
  //     final authResponse = await supabase.auth.signInWithPassword(
  //       password: newPassword,
  //     );
  //
  //     if (authResponse.user != null) {
  //       final updateResponse = await supabase.auth.updateUser(
  //         UserAttributes(password: newPassword)
  //       );
  //
  //       if (updateResponse.user != null) {
  //         Get.snackbar('Success', 'Password changed successfully');
  //         return true;
  //       } else {
  //         Get.snackbar('Error', 'Failed to change password');
  //         return false;
  //       }
  //     } else {
  //       Get.snackbar('Error', 'Authentication failed');
  //       return false;
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error','----- Error changing password: $e');
  //     return false;
  //   }
  // }
}


extension on String {
  get error => null;
}
