import 'package:better_help/core/app_route/app_route.dart';
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
    try {
      BottomNavScreenController controller =
          Get.find<BottomNavScreenController>();
      controller.changeIndex(2);
    } catch (e) {
      Get.offNamed(AppRoute.bottomNav, arguments: {'initialIndex': 2});
    }
  }

  static void navigateToProgress() {
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
