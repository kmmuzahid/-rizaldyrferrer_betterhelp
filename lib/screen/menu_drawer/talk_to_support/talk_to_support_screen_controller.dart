/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 17:37:13
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TalkToSupportScreenController extends GetxController {
  late TextEditingController feedbackController;

  @override
  void onInit() {
    feedbackController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }

  submitFeedBack(final String feedback) async {
    final result = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: AppApiurl.report,
        jsonBody: {'text': feedback},
        method: RequestMethod.POST,
      ),
      responseBuilder: (data) {
        return data;
      },
    );
    if (result.isSuccess) {
      Get.back();
    }
  }
}
