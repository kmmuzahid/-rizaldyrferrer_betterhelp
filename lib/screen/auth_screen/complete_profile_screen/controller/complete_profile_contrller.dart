import 'dart:io';

import 'package:better_help/service/image_picker_service/image_picker_service.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteProfileContrller extends GetxController {
  var selectedImage = Rxn<File>(); // Reactive variable for selected image
  var isLoading = false.obs; // Reactive variable for loading state
  var selectedGender = ''.obs; // Reactive variable for selected gender

  // Instance of ImagePickerService
  final ImagePickerService _imagePickerService = ImagePickerService();

  // Method to pick and update image
  Future<void> pickAndUpdateImage(BuildContext context) async {
    try {
      isLoading.value = true;
      appLog('🔄 Starting image selection...');
      final pickedImage = await _imagePickerService.pickImage(context);
      if (pickedImage != null) {
        appLog('✅ Image selected successfully: ${pickedImage.path}');
        selectedImage.value = pickedImage;
        //AppSnackBar.success("✅ Image selected successfully!");
      } else {
        appLog('❌ No image was selected');
      }
    } catch (e) {
      appLog('❌ Error selecting image: $e');
      //AppSnackBar.error("❌ Error selecting image: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Method to select gender
  void selectGender(String gender) {
    selectedGender.value = gender;
    appLog('✅ Gender selected: $gender');
  }
}
