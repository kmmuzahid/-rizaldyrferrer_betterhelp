import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreenController extends GetxController {
  final _authRepository = AuthReporsitory();

  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  bool _validateEmail() {
    if (emailController.text.trim().isEmpty) {
      AppSnackBar.showError("Please enter your email");
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      AppSnackBar.showError("Please enter a valid email");
      return false;
    }
    return true;
  }

  Future<void> sendCode() async {
    if (!_validateEmail()) return;

    isLoading.value = true;

    final response = await _authRepository.forgotPassword(
      email: emailController.text.trim(),
    );

    isLoading.value = false;

    if (response != null) {
      AppSnackBar.showSuccess(response['message'] ?? "OTP sent to your email");
      Get.toNamed(
        AppRoute.otpVerificationScreen,
        arguments: {
          'screen': 'forgotpassword',
          'email': emailController.text.trim(),
        },
      );
    }
  }
}
