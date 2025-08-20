import 'package:get/get.dart';

class CongratulaitonScreenController extends GetxController {
  void navigateToHomeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  @override
  void onInit() {
    super.onInit();
    navigateToHomeScreen();
  }
}
