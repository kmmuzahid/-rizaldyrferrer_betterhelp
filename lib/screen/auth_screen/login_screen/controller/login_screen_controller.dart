/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/auth/ck_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final _profileRepsitory = ProfileRepository();

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

    final result = await CkAuth.signIn(
      username: emailController.text.trim(),
      password: passwordController.text,
    );

    if (result.isSuccess) {
      final ProfileData? profileData = CkAuth.profile as ProfileData?;
      if (profileData != null) {
        Get.find<MyProfileScreenController>().profileData.value = profileData;
      }
      AppSnackBar.showSuccess(result.message ?? "Login successful");
      isLoading.value = false;
      // CoreKit's autoNavigate will handle routing based on subscription status
    } else {
      AppSnackBar.showError(result.message ?? "Login failed");
      isLoading.value = false;
    }
  }
}
