/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreenController extends GetxController {
  final _authRepository = AuthReporsitory();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final isLoading = false.obs;
  var isForgetPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      isForgetPassword.value = Get.arguments['isForgetPassword'] ?? false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }

  bool _validatePasswords() {
    if (newPasswordController.text.isEmpty ||
        currentPasswordController.text.isEmpty) {
      AppSnackBar.showError("Please enter new password");
      return false;
    }
    if (newPasswordController.text.length < 8) {
      AppSnackBar.showError("Password must be at least 8 characters");
      return false;
    }
    if (newPasswordController.text.isEmpty) {
      AppSnackBar.showError("Please confirm your password");
      return false;
    }

    return true;
  }

  Future<void> changePassword() async {
    if (!_validatePasswords()) return;
    if (isForgetPassword.value) {
      ckAuth.updatePassword(
        body: {
          "newPassword": newPasswordController.text,
          "confirmPassword": currentPasswordController.text,
        },
      );
      return;
    }

    isLoading.value = true;

    final response = isForgetPassword.value
        ? await _authRepository.forgetPassword(
            newPassword: newPasswordController.text,
            confirmPassword: currentPasswordController.text,
          )
        : await _authRepository.changePassword(
            newPassword: newPasswordController.text,
            oldPassword: currentPasswordController.text,
          );

    isLoading.value = false;

    if (response != null && response.isSuccess) {
      AppSnackBar.showSuccess(
        response.message ?? "Password changed successfully",
      );
      Get.offAllNamed(AppRoute.loginScreen);
    }
  }
}
