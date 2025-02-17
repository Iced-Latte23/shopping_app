import 'package:get/get.dart';
import '../../../data/provider/supabase_provider.dart';

class LoginController extends GetxController {
  // Observables
  var togglePassword = false.obs; // Password visibility toggle
  var isLoading = false.obs; // Loading state for login button
  var emailError = ''.obs; // Email error message
  var passwordError = ''.obs; // Password error message

  // Toggle password visibility
  void toggleShowPassword() {
    togglePassword.value = !togglePassword.value;
  }

  // Perform login with email and password
  Future<void> login(String email, String password) async {
    // Reset error message and set loading state
    emailError.value = '';
    passwordError.value = '';
    isLoading.value = true;

    try {
      // Validate input fields
      if (!_validateEmail(email)) {
        emailError.value = 'Please enter a valid email address.';
        return;
      }
      if (!_validatePassword(password)) {
        passwordError.value = 'Password must be at least 6 characters long.';
        return;
      }

      // Attempt login
      final bool success = await SupabaseProvider.instance
          .loginWithEmail(email: email, password: password);

      if (success) {
        // Navigate to home screen on successful login
        Get.offAllNamed('/home');
      } else {
        // Handle login failure
        passwordError.value = 'Invalid email or password.';
      }
    } catch (e) {
      // Handle unexpected errors
      passwordError.value = 'An error occurred. Please try again later.';
      print('Login Error: $e'); // Log the error for debugging
    } finally {
      // Reset loading state
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
}