import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionAndPaymentController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentPageIndex = 0.obs;
  final int totalPages = 4;

  // Subscription plan names
  final List<String> planNames = [
    'Momentum',
    'Accelerate',
    'Elevate',
    'Ignite',
  ];

  void nextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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

  void goToPage(int index) {
    if (index >= 0 && index < totalPages) {
      currentPageIndex.value = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  String getCurrentPlanName() {
    return planNames[currentPageIndex.value];
  }

  void selectPlan() {
    // Handle plan selection logic
    appLog('Selected plan: ${getCurrentPlanName()}');
    // Navigate to payment or next screen
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
