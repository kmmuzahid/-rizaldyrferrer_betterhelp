import 'dart:async';

import 'package:better_help/core/app_route/app_route.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  // Get arguments passed to this controller
  final arguments = Get.arguments;

  // Timer variables
  RxInt timerSeconds = 60.obs;
  RxBool isTimerActive = true.obs;
  Timer? _timer;

  // Get the source screen
  String get sourceScreen => arguments?['screen'] ?? '';

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    isTimerActive.value = true;
    timerSeconds.value = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        isTimerActive.value = false;
        timer.cancel();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  void verifyOtp(String otp) {
    if (sourceScreen == 'signup') {
      // Navigate to login screen after successful signup verification
      Get.offAllNamed(AppRoute.loginScreen);
    } else if (sourceScreen == 'forgotpassword') {
      // Navigate to change password screen
      Get.offNamed(AppRoute.changePasswrodScreen);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
