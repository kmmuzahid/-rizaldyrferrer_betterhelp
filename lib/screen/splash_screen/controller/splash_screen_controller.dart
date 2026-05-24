/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final StorageService _storageService = StorageService();
  final ProfileRepository _profileRepsitory = ProfileRepository();

  Future<void> _navigateBasedOnStoredData() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await _storageService.getAccessToken();
    final responses = await _storageService.getQuestionnaireResponses();

    // Case 1: Has accessToken -> Go to subscription screen (app)
    if (accessToken != null && accessToken.isNotEmpty) {
      print(" accessToken accessToken accessToken");
      final profile = await _profileRepsitory.getMyProfile();
      ProfileData? profileData;
      if (profile.isSuccess) {
        profileData = profile.data;
        print(
          " profileData profileData profileData ${profileData?.subscriptionPackageId}",
        );
        Get.find<MyProfileScreenController>().profileData.value = profileData;
      }

      if (profileData?.subscriptionPackageId == null) {
        print(" subscriptionscreen subscriptionscreen subscriptionscreen");
        Get.offAllNamed(AppRoute.subscriptionscreen);
      } else {
        Get.offAllNamed(AppRoute.bottomNav);
      }
      return;
    }

    // Case 3: NO accessToken but HAS questionnaire responses -> Go to free trial
    if ((accessToken == null || accessToken.isEmpty) &&
        responses != null &&
        responses.isNotEmpty) {
      Get.offNamed(AppRoute.signupScreen);
      return;
    }

    // Case 4: NO accessToken and NO questionnaire responses -> Go to onboarding
    Get.offNamed(AppRoute.onboardingscreen);
  }

  @override
  void onInit() async {
    super.onInit();
    StorageService.instance.removeQuestionnaireOutput();
    StorageService.instance.removeQuestionnaireResponses();
    _navigateBasedOnStoredData();
  }
}
