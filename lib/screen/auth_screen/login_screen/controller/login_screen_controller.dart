/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final _authRepository = AuthReporsitory();

  // Text controllers
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
      await StorageService.instance.saveAccessToken(response['data']['accessToken']);
      await StorageService.instance.saveRefreshToken(response['data']['refreshToken']);
      await StorageService.instance.saveUserData(response['data']['user']);
      AppSnackBar.showSuccess(response['message'] ?? "Login successful");
      Get.offAllNamed(AppRoute.subscriptionscreen);
    }
  }
}
