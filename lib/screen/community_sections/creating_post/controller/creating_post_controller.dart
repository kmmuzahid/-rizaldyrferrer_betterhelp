import 'package:better_help/screen/community_sections/main_community/controller/community_screen_controller.dart';
import 'package:better_help/service/repository/community_repository/community_repository.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatingPostController extends GetxController {
  final _repository = CommunityRepository();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  bool _validate() {
    if (contentController.text.trim().isEmpty) {
      AppSnackBar.showError("Please enter content");
      return false;
    }
    return true;
  }

  Future<void> submitPost() async {
    if (!_validate()) return;

    isSubmitting.value = true;

    try {
      final body = {"description": contentController.text.trim()};

      final response = await _repository.createApost(body);

      isSubmitting.value = false;

      if (response != null && response.isSuccess) {
        CkSnackBar(
          response.message ?? "Post created successfully",
          type: .success,
        );

        if (Get.isRegistered<CommunityScreenController>()) {
          final communityController = Get.find<CommunityScreenController>();
          await communityController.refreshPosts();
        }

        Get.back();
      } else {
        CkSnackBar("Failed to create post", type: .error);
      }
    } catch (e) {
      isSubmitting.value = false;
      appLog('CreatingPostController submitPost error: $e');
      CkSnackBar("Something went wrong. Please try again.", type: .error);
    }
  }
}
