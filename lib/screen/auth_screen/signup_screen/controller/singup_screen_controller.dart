import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/auth_screen/auth_repository/auth_reporsitory.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingupScreenController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isObscure = true.obs;
  RxBool isConfirmObscure = true.obs;
  RxBool isLoading = false.obs;

  final _authRepository = AuthReporsitory();
  final _storageService = StorageService();

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Validates the signup form
  bool _validateForm() {
    if (fullNameController.text.trim().isEmpty) {
      AppSnackBar.showError("Please enter your full name");
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      AppSnackBar.showError("Please enter your email");
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      AppSnackBar.showError("Please enter a valid email");
      return false;
    }
    if (passwordController.text.isEmpty) {
      AppSnackBar.showError("Please enter your password");
      return false;
    }
    if (passwordController.text.length < 6) {
      AppSnackBar.showError("Password must be at least 6 characters");
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      AppSnackBar.showError("Please confirm your password");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      AppSnackBar.showError("Passwords do not match");
      return false;
    }
    return true;
  }

  /// Handles the signup process
  Future<void> signUp() async {
    if (!_validateForm()) return;

    appLog('SignupController: Starting signup process...');
    isLoading.value = true;

    try {
      final response = await _authRepository.createUser(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response != null) {
        appLog('SignupController: Signup successful');

        // Save createUserToken from response
        if (response['data'] != null &&
            response['data']['createUserToken'] != null) {
          await _storageService.saveCreateUserToken(
            response['data']['createUserToken'],
          );
          appLog('SignupController: createUserToken saved to storage');
        }

        AppSnackBar.showSuccess("Account created successfully!");
        Get.toNamed(
          AppRoute.otpVerificationScreen,
          arguments: {'screen': "signup", 'email': emailController.text.trim()},
        );
      } else {
        appLog('SignupController: Signup failed');
      }
    } catch (e) {
      appLog('SignupController: Exception - $e');
      AppSnackBar.showError("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
