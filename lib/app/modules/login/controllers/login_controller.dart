import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/provider/supabase_provider.dart';

class LoginController extends GetxController {
  // Observables
  var togglePassword = false.obs;
  var isLoading = false.obs;
  var emailVerified = false.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var userEmail = ''.obs;
  final RxString errorMessage = ''.obs;

  void toggleShowPassword() {
    togglePassword.value = !togglePassword.value;
  }

  Future<void> login(String email, String password) async {
    emailError.value = '';
    passwordError.value = '';
    isLoading.value = true;

    try {
      if (!_validateEmail(email)) {
        emailError.value = 'Please enter a valid email address.';
        return;
      }
      if (!_validatePassword(password)) {
        passwordError.value = 'Password must be at least 6 characters long.';
        return;
      }

      final response =
          await SupabaseProvider.instance.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        Get.offAllNamed('/home');
      } else {
        passwordError.value = 'Invalid email or password.';
      }
    } catch (e) {
      passwordError.value = 'An error occurred. Please try again later.';
      print('Login Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Validate email format
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  // Validate password length
  bool _validatePassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (!_validatePassword(newPassword)) {
        errorMessage.value = 'Password must be at least 6 characters long.';
        return;
      }

      final updateResponse = await SupabaseProvider.instance.supabase.auth
          .updateUser(UserAttributes(email: userEmail.value, password: newPassword));
      if (updateResponse.error != null) {
        errorMessage.value =
            'Failed to update password: ${updateResponse.error!.message}';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.TOP);
        return;
      }

      Get.snackbar('Success', 'Password changed successfully!',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      print('Password Update Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate input
      if (!_validateEmail(email)) {
        errorMessage.value = 'Please enter a valid email address.';
        return false;
      }

      final response = await SupabaseProvider.instance.supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .single();
      if (response == null) {
        errorMessage.value = 'Email not found.';
        return emailVerified.value = false;
      }

      userEmail.value = email;
      return emailVerified.value = true;
    } catch (e) {
      print('‼️ Email Check Error: $e');
      return emailVerified.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}

extension on bool {
  get user => null;
}

extension on UserResponse {
  get error => null;
}
