/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 17:37:13
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
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
    final result = await CkTransport.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.report,
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
