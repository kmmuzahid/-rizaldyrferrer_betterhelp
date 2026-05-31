/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 18:13:30
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PrivacyPolicyScreenController extends GetxController {
  var isLoading = false.obs;
  var privacyPolicy = "".obs;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  fetch() async {
    isLoading.value = true;

    final result = await CkTransport.request<String>(
      input: RequestInput(endpoint: ApiEndPoints.privacyPolicy, method: RequestMethod.GET),
      responseBuilder: (data) {
        return data?['privacyPolicy']?.toString() ?? '';
      },
    );
    privacyPolicy.value = result.data ?? '';
    isLoading.value = false;
  }
}
