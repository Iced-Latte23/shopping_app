import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),

              // Welcome Text
              const Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              _buildLabel("Email"),
              _buildTextField(
                hintText: "Enter your email",
                controller: emailController,
                prefixIcon: Icons.email_outlined,
                keyType: TextInputType.emailAddress,
                errorController: controller.emailError,
              ),
              Obx(() =>
                  Visibility(
                    visible: controller.emailError.value.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        controller.emailError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  )),
              const SizedBox(height: 15),

              // Password Field
              _buildLabel("Password"),
              Obx(() =>
                  _buildTextField(
                    hintText: "Enter your password",
                    controller: passwordController,
                    obscureText: !controller.togglePassword.value,
                    errorController: controller.passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(controller.togglePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => controller.toggleShowPassword(),
                    ),
                    prefixIcon: Icons.lock_outline,
                  )),
              Obx(() =>
                  Visibility(
                    visible: controller.passwordError.value.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        controller.passwordError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  )),
              const SizedBox(height: 25),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                      await controller.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: controller.isLoading.value
                          ? Colors.grey[400]
                          : Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: controller.isLoading.value
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Logging In...",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                        : const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 5),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showResetPassDialog(controller);
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Divider
              Row(
                children: [
                  const Expanded(
                      child: Divider(thickness: 1, color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  const Expanded(
                      child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),

              // Social Login Buttons
              Row(
                children: [
                  _buildSocialButton(
                      Icons.g_mobiledata_sharp, "Google", Colors.red, () {}),
                  const SizedBox(width: 10),
                  _buildSocialButton(
                      Icons.facebook, "Facebook", Colors.blue, () {}),
                ],
              ),
              const SizedBox(height: 30),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/signup');
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Label Widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Text Field Widget
  Widget _buildTextField(
      {RxString? errorController, TextInputType? keyType ,required String hintText, bool obscureText = false, Widget? suffixIcon, IconData? prefixIcon, TextEditingController? controller}) {
    return TextFormField(
      controller: controller, // Assign the controller
      obscureText: obscureText,
      keyboardType: keyType,
      onChanged: (value) {
        if (errorController != null && value.isNotEmpty){
          errorController.value ='';
        }
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
          BorderSide(color: Theme
              .of(Get.context!)
              .primaryColor, width: 2),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey[600])
            : null,
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(fontSize: 16),
    );
  }


  // Social Login Button Widget
  Expanded _buildSocialButton(IconData icon, String text, Color color,
      VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 8),
              Text(
                text,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showResetPassDialog(LoginController controller) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    // Clear previous errors
    controller.errorMessage.value = '';

    Get.defaultDialog(
      title: 'Reset Password',
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
              // Email Input Field (Initial State)
              if (!controller.emailVerified.value)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: 'Email',
                        hintText: 'Enter your email',
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
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
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

                        // Verify Email Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                              final email = emailController.text.trim();
                              if (email.isEmpty || !email.contains('@')) {
                                controller.errorMessage.value =
                                'Please enter a valid email address.';
                                return;
                              }

                              // Check if email exists
                              final emailExists =
                              await controller.checkEmailExists(email);
                              if (emailExists) {
                                // Transition to password reset form
                                controller.emailVerified.value = true;
                                controller.errorMessage.value = '';
                              } else {
                                controller.errorMessage.value =
                                'Email not found.';
                              }
                            },
                            style: ElevatedButton.styleFrom(
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
                              'Verify Email',
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

              // Password Reset Form (After Email Verification)
              if (controller.emailVerified.value)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: newPasswordController,
                      obscureText: !controller.togglePassword.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(controller.togglePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => controller.toggleShowPassword(),
                        ),
                        prefixIcon: Icon(Icons.lock_outline),
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
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
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              controller.errorMessage.value = '';
                              controller.emailVerified.value = false;
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

                        // Save Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                              final newPassword =
                              newPasswordController.text.trim();
                              await controller.resetPassword(newPassword);
                              if (controller.errorMessage.value.isEmpty) {
                                Get.back();
                                Get.snackbar(
                                  'Success',
                                  'Password updated successfully!',
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
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
            ],
          ),
        );
      }),
    );
  }
}
