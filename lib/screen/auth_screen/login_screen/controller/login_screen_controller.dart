/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final _authRepository = AuthReporsitory();
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

    final response = await _authRepository.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (response?.isSuccess ?? false) {
      await StorageService.instance.saveAccessToken(
        response!.data['accessToken'],
      );
      await StorageService.instance.saveRefreshToken(
        response.data['refreshToken'],
      );
      await StorageService.instance.saveUserData(response.data['user']);

      final profile = await _profileRepsitory.getMyProfile();
      ProfileData? profileData;
      if (profile.isSuccess) {
        profileData = response.data;
        Get.find<MyProfileScreenController>().profileData.value = profileData;
      }
      AppSnackBar.showSuccess(response.message ?? "Login successful");
      isLoading.value = false;

      if (profileData?.subscriptionPackageId == null) {
        Get.offAllNamed(AppRoute.subscriptionscreen);
      } else {
        Get.offAllNamed(AppRoute.bottomNav);
      }
    }
  }
}
