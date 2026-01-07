import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreenController extends GetxController {
  final PageController pageController = PageController();
  final _storageService = StorageService();

  RxInt currentPageIndex = 0.obs;
  final int totalPages = 5;
  RxList onboardingData = [
    AppColors.onboardingBackground01,
    AppColors.onboardingBackground02,
    AppColors.onboardingBackground03,
    AppColors.onboardingBackground04,
    AppColors.onboardingBackground05,
  ].obs;

  void nextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to subscription screen when onboarding is finished
      goToSubscriptionScreen();
    }
  }

  void previousPage() {
    if (currentPageIndex.value > 0) {
      currentPageIndex.value--;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    //! Navigate to subscription screen
    goToSubscriptionScreen();
  }

  Future<void> goToSubscriptionScreen() async {
    //! Clean up any existing controllers before navigation
    Get.delete<OnboardingScreenController>();

    //! Check if questionnaire responses are already saved
    final savedResponses = await _storageService.getQuestionnaireResponses();

    if (savedResponses != null && savedResponses.isNotEmpty) {
      //! Questionnaire already completed, skip to free trial screen
      appLog('Questionnaire responses found, navigating to free trial screen');
      Get.offAllNamed(AppRoute.freeTrialScreen);
    } else {
      //! No saved responses, navigate to before question screen
      appLog(
        'No questionnaire responses found, navigating to before question screen',
      );
      Get.offAllNamed(AppRoute.beforeQuestionScreen);
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
