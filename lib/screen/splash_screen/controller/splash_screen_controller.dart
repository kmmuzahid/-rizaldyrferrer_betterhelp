import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final StorageService _storageService = StorageService();

  Future<void> _navigateBasedOnStoredData() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await _storageService.getAccessToken();
    final responses = await _storageService.getQuestionnaireResponses();

    // Case 1: Has accessToken AND questionnaire responses -> Go to bottomNav (logged in)
    if (accessToken != null &&
        accessToken.isNotEmpty &&
        responses != null &&
        responses.isNotEmpty) {
      appLog(accessToken);
      Get.offNamed(AppRoute.bottomNav);
      return;
    }

    // Case 2: Has accessToken but NO questionnaire responses -> Go to questionnaire
    if (accessToken != null &&
        accessToken.isNotEmpty &&
        (responses == null || responses.isEmpty)) {
      Get.offNamed(AppRoute.beforeQuestionScreen);
      return;
    }

    // Case 3: NO accessToken but HAS questionnaire responses -> Go to free trial
    if ((accessToken == null || accessToken.isEmpty) &&
        responses != null &&
        responses.isNotEmpty) {
      Get.offNamed(AppRoute.freeTrialScreen);
      return;
    }

    // Case 4: NO accessToken and NO questionnaire responses -> Go to onboarding
    Get.offNamed(AppRoute.onboardingscreen);
  }

  @override
  void onInit() {
    super.onInit();
    _navigateBasedOnStoredData();
  }
}
