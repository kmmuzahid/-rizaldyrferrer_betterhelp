/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 18:13:30
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
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

    final result = await DioService.instance.request(
      input: RequestInput(endpoint: AppApiurl.privacyPolicy, method: RequestMethod.GET),
      responseBuilder: (response) {
        return response['privacyPolicy']?.toString() ?? '';
      },
    );
    privacyPolicy.value = result.data ?? '';
    isLoading.value = false;
  }
}
