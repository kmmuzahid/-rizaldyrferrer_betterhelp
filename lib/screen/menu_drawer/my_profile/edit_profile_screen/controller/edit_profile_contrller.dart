import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/service/image_picker_service/image_picker_service.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;

class EditProfileContrller extends GetxController {
  final _profileRepository = ProfileRepository();
  final ImagePickerService _imagePickerService = ImagePickerService();

  var selectedImage = Rxn<XFile>();
  var isLoading = false.obs;
  var isSaving = false.obs;
  var _hasLoadedData = false; // Flag to prevent duplicate loads

  // Text controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Profile data
  var profileData = Rxn<ProfileData>();

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
    isLoading.value = true;
    appLog('🔄 Loading profile data for edit...');

    final response = await _profileRepository.getMyProfile();

    if (response.isSuccess) {
      profileData.value = response.data;

      // Populate controllers with existing data
      fullNameController.text = profileData.value?.fullName ?? '';
      phoneController.text = profileData.value?.phone ?? '';
      addressController.text = profileData.value?.address ?? '';

      _hasLoadedData = true; // Mark as loaded
      appLog('✅ Profile data loaded successfully');
    }

    isLoading.value = false;
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
        profile: selectedImage.value,
      );

      if (response.isSuccess) {
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
        AppSnackBar.showError(response.message ?? "Failed to update profile");
      }
    } catch (e) {
      appLog('❌ Error updating profile: $e');
      AppSnackBar.showError("Error updating profile: ${e.toString()}");
    } finally {
      isSaving.value = false;
    }
  }
}
