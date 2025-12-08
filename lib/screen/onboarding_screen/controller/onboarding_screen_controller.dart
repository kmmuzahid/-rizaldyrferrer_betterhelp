import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreenController extends GetxController {
  final PageController pageController = PageController();
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

  void goToSubscriptionScreen() {
    //!  Replace with your actual subscription screen route
    //! Get.offNamed('/subscription');
    Get.offAllNamed(AppRoute.questionariescreen);
    appLog('Navigate to subscription screen');
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
