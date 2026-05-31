/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 17:45:43
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get.dart';

class TermsAndConditionsScreenController extends GetxController {
  var isLoading = false.obs;
  var termsAndConditions = "".obs;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  fetch() async {
    isLoading.value = true;

    final result = await CkTransport.request<String>(
      input: RequestInput(endpoint: ApiEndPoints.termsOfService, method: RequestMethod.GET),
      responseBuilder: (data) {
        return data?['termsOfService']?.toString() ?? '';
      },
    );
    termsAndConditions.value = result.data ?? '';
    isLoading.value = false;
  }
}
