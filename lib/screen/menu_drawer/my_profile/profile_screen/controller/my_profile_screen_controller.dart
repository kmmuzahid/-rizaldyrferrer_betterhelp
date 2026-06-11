/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 19:55:25
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:get/get.dart';

class MyProfileScreenController extends GetxController {
  final _profileRepository = ProfileRepository();

  var isLoading = false.obs;
  var isNotificationListening = false.obs;

  RxBool isReplaceBhaBhaaLoading = false.obs;

  Future<void> replaceBhaBhaa({
    required String choice,
    required String reason,
  }) async {
    if (isReplaceBhaBhaaLoading.value) return;
    isReplaceBhaBhaaLoading.value = true;
    await CkTransport.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.bhaBhaaReassignRequest,
        method: RequestMethod.POST,
        jsonBody: {
          "reason": reason,
          "assignPersonRole": choice == 'BHA' ? 'doctor' : 'assistant',
        },
      ),
      responseBuilder: (data) => data,
    );
    isReplaceBhaBhaaLoading.value = false;
  }
}
