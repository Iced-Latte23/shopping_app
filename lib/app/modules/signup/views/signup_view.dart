import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              SizedBox(height: MediaQuery.of(context).padding.top + 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Get Started Now',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Create an account to explore our app',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),

              // First & Last Name Fields
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.firstNameController,
                      hintText: "First Name",
                      errorText: controller.firstNameError,
                      onChanged: (value) => controller.firstNameError.value = '',
                      prefixIcon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.lastNameController,
                      hintText: "Last Name",
                      errorText: controller.lastNameError,
                      onChanged: (value) => controller.lastNameError.value = '',
                      prefixIcon: Icons.person_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Email Field
              _buildTextField(
                controller: controller.emailController,
                hintText: "Email",
                errorText: controller.emailError,
                onChanged: (value) => controller.emailError.value = '',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),

              // Password Field with Toggle
              Obx(() => _buildTextField(
                controller: controller.passwordController,
                hintText: "Password",
                obscureText: controller.isPasswordHidden.value,
                suffixIcon: _passwordIcon(controller.isPasswordHidden.value),
                onSuffixTap: controller.togglePasswordVisibility,
                errorText: controller.passwordError,
                onChanged: (value) => controller.passwordError.value = '',
                prefixIcon: Icons.lock_outline,
              )),
              const SizedBox(height: 15),

              // Confirm Password Field with Toggle
              Obx(() => _buildTextField(
                controller: controller.confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: controller.isConfirmPasswordHidden.value,
                suffixIcon:
                _passwordIcon(controller.isConfirmPasswordHidden.value),
                onSuffixTap: controller.toggleConfirmPasswordVisibility,
                errorText: controller.confirmPasswordError,
                onChanged: (value) =>
                controller.confirmPasswordError.value = '',
                prefixIcon: Icons.lock_outline,
              )),
              const SizedBox(height: 25),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => controller.signUp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () => Get.offAllNamed('/login'),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Text Field Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required RxString errorText,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onSuffixTap,
    ValueChanged<String>? onChanged,
  }) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: errorText.value.isNotEmpty ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: errorText.value.isNotEmpty
                    ? Colors.red
                    : Theme.of(Get.context!).primaryColor,
                width: 2,
              ),
            ),
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey[600])
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(onTap: onSuffixTap, child: suffixIcon)
                : null,
            errorText: errorText.value.isNotEmpty ? errorText.value : null,
          ),
        ),
        const SizedBox(height: 5),
      ],
    ));
  }

  // Password Visibility Icon
  Widget _passwordIcon(bool isHidden) {
    return Icon(
      isHidden ? Icons.visibility_off : Icons.visibility,
      color: Colors.grey[600],
    );
  }
}