/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 16:01:41
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get.dart';

import '../../core/app_apiurl/api_end_points.dart';

class ReportController extends GetxController {
  // Selected category state
  var selectedCategory = "".obs;

  var report = '';

  final List<String> categories = [
    "Technical Issue",
    "Account Problem",
    "Billing/Payment",
    "App Feedback",
    "Other",
  ];

  void setCategory(String? value) {
    if (value != null) selectedCategory.value = value;
  }

  void submitReport() async {
    if (report.isNotEmpty) {
      final result = await CkTransport.request(
        showMessage: true,
        input: RequestInput(
          endpoint: ApiEndPoints.report,
          method: RequestMethod.POST,
          jsonBody: {"text": report},
        ),
        responseBuilder: (data) => data,
      );
      if (result.isSuccess) {
        Get.back();
      }
    }
  }
}
