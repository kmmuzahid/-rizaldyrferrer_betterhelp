import 'dart:async';

import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/auth_screen/auth_repository/auth_reporsitory.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  // Get arguments passed to this controller
  final arguments = Get.arguments;

  // Repository
  final _authRepository = AuthReporsitory();

  // Timer variables
  RxInt timerSeconds = 60.obs;
  RxBool isTimerActive = true.obs;
  RxBool isLoading = false.obs;
  Timer? _timer;

  // Get the source screen
  String get sourceScreen => arguments?['screen'] ?? '';
  String get email => arguments?['email'] ?? '';

  @override
  void onInit() {
    super.onInit();
    startTimer();
    appLog('OtpVerificationController: Source screen - $sourceScreen');
    appLog('OtpVerificationController: Email - $email');
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

  void resetTimer() async {
    if (email.isNotEmpty) {
      appLog('OtpVerificationController: Resending OTP to $email');
      final response = await _authRepository.resendOtp(email: email);
      if (response != null) {
        AppSnackBar.showSuccess('OTP sent successfully');
      }
    }
    _timer?.cancel();
    startTimer();
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) {
      AppSnackBar.showError('Please enter a valid 6-digit OTP');
      return;
    }

    appLog('OtpVerificationController: Verifying OTP - $otp');
    isLoading.value = true;

    try {
      if (sourceScreen == 'signup') {
        // Call verify OTP API with questionnaire responses
        final response = await _authRepository.verifyOtp(otp: otp);

        if (response != null) {
          appLog('OtpVerificationController: OTP verified successfully');
          AppSnackBar.showSuccess('Account verified successfully!');
          Get.offAllNamed(AppRoute.loginScreen);
        } else {
          appLog('OtpVerificationController: OTP verification failed');
        }
      } else if (sourceScreen == 'forgotpassword') {
        // For forgot password, just verify OTP without responses
        final response = await _authRepository.verifyOtp(otp: otp);

        if (response != null) {
          Get.offNamed(AppRoute.changePasswrodScreen);
        }
      }
    } catch (e) {
      appLog('OtpVerificationController: Exception - $e');
      AppSnackBar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
