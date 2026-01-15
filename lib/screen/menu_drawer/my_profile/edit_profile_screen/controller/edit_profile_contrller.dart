import 'dart:io';

import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/service/image_picker_service/image_picker_service.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;

class EditProfileContrller extends GetxController {
  final _profileRepository = ProfileRepository();
  final ImagePickerService _imagePickerService = ImagePickerService();

  var selectedImage = Rxn<File>();
  var isLoading = false.obs;
  var isSaving = false.obs;
  var _hasLoadedData = false; // Flag to prevent duplicate loads

  // Text controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Profile data
  var profileData = Rxn<Data>();

  @override
  void onInit() {
    super.onInit();
    if (!_hasLoadedData) {
      loadProfileData();
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;
      appLog('🔄 Loading profile data for edit...');

      final response = await _profileRepository.getMyProfile();

      if (response != null && response['success'] == true) {
        final profileResponse = Welcome.fromJson(response);
        profileData.value = profileResponse.data;

        // Populate controllers with existing data
        fullNameController.text = profileData.value?.fullName ?? '';
        phoneController.text = profileData.value?.phone ?? '';
        addressController.text = profileData.value?.address ?? '';

        _hasLoadedData = true; // Mark as loaded
        appLog('✅ Profile data loaded successfully');
      }
    } catch (e) {
      appLog('❌ Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUpdateImage(BuildContext context) async {
    try {
      isLoading.value = true;
      appLog('🔄 Starting image selection...');
      final pickedImage = await _imagePickerService.pickImage(context);
      if (pickedImage != null) {
        appLog('✅ Image selected successfully: ${pickedImage.path}');
        selectedImage.value = pickedImage;
      } else {
        appLog('❌ No image was selected');
      }
    } catch (e) {
      appLog('❌ Error selecting image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isSaving.value = true;

      // Validate that at least one field is filled
      if (fullNameController.text.trim().isEmpty &&
          phoneController.text.trim().isEmpty &&
          addressController.text.trim().isEmpty &&
          selectedImage.value == null) {
        AppSnackBar.showError("Please update at least one field");
        return;
      }

      // Prepare image for upload if selected
      dio.MultipartFile? imageFile;
      if (selectedImage.value != null) {
        appLog('📸 Preparing image for upload: ${selectedImage.value!.path}');
        try {
          imageFile = await dio.MultipartFile.fromFile(
            selectedImage.value!.path,
            filename: selectedImage.value!.path.split('/').last,
          );
          appLog('✅ Image file prepared successfully');
        } catch (e) {
          appLog('❌ Error preparing image: $e');
          AppSnackBar.showError("Error preparing image for upload");
          return;
        }
      }

      appLog('🔄 Sending update profile request...');
      appLog('Full Name: ${fullNameController.text.trim()}');
      appLog('Phone: ${phoneController.text.trim()}');
      appLog('Address: ${addressController.text.trim()}');
      appLog('Has Image: ${imageFile != null}');

      final response = await _profileRepository.updateMyProfile(
        fullName: fullNameController.text.trim().isNotEmpty
            ? fullNameController.text.trim()
            : null,
        phone: phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
        address: addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        profile: imageFile,
      );

      appLog('📥 Response received: $response');

      if (response != null && response['success'] == true) {
        appLog('✅ Profile updated successfully');
        AppSnackBar.showSuccess("Profile updated successfully");

        // Clean up controller before going back
        Get.delete<EditProfileContrller>(tag: 'edit_profile');
        Get.back(); // Go back to profile screen

        // Refresh profile screen if controller exists
        if (Get.isRegistered<MyProfileScreenController>()) {
          Get.find<MyProfileScreenController>().fetchProfile();
        }
      } else {
        appLog('❌ Update failed: ${response?['message']}');
        AppSnackBar.showError(
          response?['message'] ?? "Failed to update profile",
        );
      }
    } catch (e) {
      appLog('❌ Error updating profile: $e');
      AppSnackBar.showError("Error updating profile: ${e.toString()}");
    } finally {
      isSaving.value = false;
    }
  }
}
