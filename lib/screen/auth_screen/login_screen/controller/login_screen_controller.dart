/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final _authRepository = AuthReporsitory();

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Loading state
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Validate inputs
  bool _validateInputs() {
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
    return true;
  }

  // Login method
  Future<void> login() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    final response = await _authRepository.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    isLoading.value = false;

    if (response != null && response['success'] == true) {
      AppSnackBar.showSuccess(response['message'] ?? "Login successful");
      Get.offAllNamed(AppRoute.subscriptionscreen);
    }
  }
}
