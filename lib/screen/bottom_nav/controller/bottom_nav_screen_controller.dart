/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/learn_sections/main_learn/controller/learn_screen_controller.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/supports_sections/main_supports/controller/support_screen_controller.dart';
import 'package:core_kit/snackbar/ck_snackbar.dart';
import 'package:get/get.dart';

class BottomNavScreenController extends GetxController {
  var selectedIndex = 0.obs;
  var productDetailsArguments = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['initialIndex'] != null) {
        selectedIndex.value = Get.arguments['initialIndex'];
      }
      if (Get.arguments['productId'] != null) {
        productDetailsArguments.value = {'id': Get.arguments['productId']};
      }
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;

    // Clear product details arguments when navigating away from product details
    if (index != 4) {
      productDetailsArguments.clear();
    }
    if (index == 2) {
      Get.find<SupportScreenController>().fetchBookingSession(page: 1);
    }
    if (index == 1) {
      Get.find<LearnScreenController>().fetchCategory();
    }
  }

  static void navigateToHabits() {
    try {
      BottomNavScreenController controller =
          Get.find<BottomNavScreenController>();
      controller.changeIndex(0);
    } catch (e) {
      Get.offNamed(AppRoute.bottomNav, arguments: {'initialIndex': 0});
    }
  }

  static void navigateToLearn() {
    try {
      BottomNavScreenController controller =
          Get.find<BottomNavScreenController>();
      controller.changeIndex(1);
    } catch (e) {
      Get.offNamed(AppRoute.bottomNav, arguments: {'initialIndex': 1});
    }
  }

  static void navigateToSupport() {
    MyProfileScreenController myProfileScreenController =
        Get.find<MyProfileScreenController>();
    if (myProfileScreenController.profileData.value?.subscriptionPlanType ==
            'free' ||
        myProfileScreenController.profileData.value?.subscriptionPlanType ==
            null) {
      CkSnackBar('Upgrade Your Plan', type: .warning);
      return;
    }
    try {
      BottomNavScreenController controller =
          Get.find<BottomNavScreenController>();

      controller.changeIndex(2);
    } catch (e) {
      Get.offNamed(AppRoute.bottomNav, arguments: {'initialIndex': 2});
    }
  }

  static void navigateToProgress() {
    MyProfileScreenController myProfileScreenController =
        Get.find<MyProfileScreenController>();
    if (myProfileScreenController.profileData.value?.subscriptionPlanType ==
            'free' ||
        myProfileScreenController.profileData.value?.subscriptionPlanType ==
            null) {
      CkSnackBar('Upgrade Your Plan', type: .warning);
      return;
    }
    try {
      BottomNavScreenController controller =
          Get.find<BottomNavScreenController>();
      controller.changeIndex(3);
    } catch (e) {
      Get.offNamed(AppRoute.bottomNav, arguments: {'initialIndex': 3});
    }
  }

  static void navigateToCommunity() {
    try {
      BottomNavScreenController controller =
          Get.find<BottomNavScreenController>();
      controller.changeIndex(4);
    } catch (e) {
      Get.offNamed(AppRoute.bottomNav, arguments: {'initialIndex': 4});
    }
  }

  // static void navigateToProductDetails(String productId) {
  //   try {
  //     BottomNavScreenController controller = Get.find<BottomNavScreenController>();
  //     controller.productDetailsArguments.value = {'id': productId};
  //     controller.changeIndex(4);
  //   } catch (e) {
  //     Get.offNamed(
  //       AppRoutes.userNavigationScreen,
  //       arguments: {'initialIndex': 4, 'productId': productId},
  //     );
  //   }
  // }
}
