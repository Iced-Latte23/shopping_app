import 'package:final_project/app/data/provider/supabase_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignupController extends GetxController {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var firstNameError = ''.obs;
  var lastNameError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  bool validateFields() {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    firstNameError.value = '';
    lastNameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';

    if (firstName.isEmpty) {
      firstNameError.value = "First name is required";
    }

    // Validate last name
    if (lastName.isEmpty) {
      lastNameError.value = "Last name is required";
    }

    // Validate email
    if (email.isEmpty) {
      emailError.value = "Email is required";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError.value = "Invalid email format";
    }

    // Validate password
    if (password.isEmpty) {
      passwordError.value = "Password is required";
    } else if (password.length < 6) {
      passwordError.value = "Password must be at least 6 characters long";
    } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(password)) {
      passwordError.value =
      "Password must contain at least one letter, one number, and be at least 6 characters long";
    }

    // Validate confirm password
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Confirm password is required";
    } else if (password != confirmPassword) {
      confirmPasswordError.value = "Passwords do not match";
    }

    return [
      firstNameError,
      lastNameError,
      emailError,
      passwordError,
      confirmPasswordError
    ].every((error) => error.value.isEmpty);
  }

  void signUp() async {
    if (!validateFields()) {
      return;
    }

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Sign up user with Supabase Auth
      bool signUpSuccess = await SupabaseProvider.instance
          .signUpWithEmail(email: email, password: password);
      if (!signUpSuccess) {
        Get.snackbar(
          "Error",
          "Failed to sign up",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Store user data in Supabase
      final userData = await SupabaseProvider.instance.addUser(
          firstName: firstName, lastName: lastName, email: email, img: "");

      if (userData != null) {
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            title: const Text(
              "Success",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: const Text(
              "Account created successfully!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/login');
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to store user data",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to sign up: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
