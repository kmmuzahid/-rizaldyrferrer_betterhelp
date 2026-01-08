import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreenController extends GetxController {
  final _authRepository = AuthReporsitory();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  bool _validatePasswords() {
    if (newPasswordController.text.isEmpty) {
      AppSnackBar.showError("Please enter new password");
      return false;
    }
    if (newPasswordController.text.length < 8) {
      AppSnackBar.showError("Password must be at least 8 characters");
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      AppSnackBar.showError("Please confirm your password");
      return false;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      AppSnackBar.showError("Passwords do not match");
      return false;
    }
    return true;
  }

  Future<void> changePassword() async {
    if (!_validatePasswords()) return;

    isLoading.value = true;

    final response = await _authRepository.resetPassword(
      newPassword: newPasswordController.text,
    );

    isLoading.value = false;

    if (response != null) {
      AppSnackBar.showSuccess(
        response['message'] ?? "Password changed successfully",
      );
      Get.offAllNamed(AppRoute.loginScreen);
    }
  }
}
