import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;

class EditProfileContrller extends GetxController {
  var selectedImage = Rxn<XFile>();
  var isSaving = false.obs;
  final _hasLoadedData = false; // Flag to prevent duplicate loads

  // Text controllers
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void onInit() {
    fullNameController = TextEditingController(text: ckAuth.profile?.fullName);
    phoneController = TextEditingController(text: ckAuth.profile?.phone);
    addressController = TextEditingController(text: ckAuth.profile?.address);
    super.onInit();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> updateProfile() async {
    // Validate that at least one field is filled
    if (fullNameController.text.trim().isEmpty &&
        phoneController.text.trim().isEmpty &&
        addressController.text.trim().isEmpty &&
        selectedImage.value == null) {
      AppSnackBar.showError("Please update at least one field");
      return;
    }

    print("😀😀😀😀😀😀😀😀😀😀😀😀");

    print("Selected Image: ${selectedImage.value}");
    print("Full Name: ${fullNameController.text.trim()}");
    print("Phone: ${phoneController.text.trim()}");
    print("Address: ${addressController.text.trim()}");

    final response = await ckAuth.updateProfile(
      formFields: {
        'fullName': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
      },
      files: {'profile': ?selectedImage.value},
    );

    if (response.isSuccess) {
      Get.back(); // Go back to profile screen
    }
  }
}
