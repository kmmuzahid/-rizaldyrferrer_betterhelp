import 'package:better_help/core/app_route/app_route.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  void navigateToHomeScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(AppRoute.bottomNav);
    });
  }

  @override
  void onInit() {
    super.onInit();
    navigateToHomeScreen();
  }
}
