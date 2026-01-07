import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final StorageService _storageService = StorageService();

  Future<void> _navigateBasedOnStoredData() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await _storageService.getAccessToken();

    // If user has access token, go directly to bottomNav (logged in)
    if (accessToken != null && accessToken.isNotEmpty) {
      Get.offNamed(AppRoute.bottomNav);
      
    }

    // Check if questionnaire responses are saved
    final responses = await _storageService.getQuestionnaireResponses();

    if (responses != null && responses.isNotEmpty) {
      // User has completed questionnaire, go to free trial screen
      Get.offNamed(AppRoute.freeTrialScreen);
    } else {
      // No questionnaire data, go to onboarding
      Get.offNamed(AppRoute.onboardingscreen);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _navigateBasedOnStoredData();
  }
}
