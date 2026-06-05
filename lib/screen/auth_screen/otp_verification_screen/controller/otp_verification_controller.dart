import 'dart:async';

import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/service/repository/auth_repository/auth_reporsitory.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  final arguments = Get.arguments;
  final _authRepository = AuthReporsitory();

  RxInt timerSeconds = 60.obs;
  RxBool isTimerActive = true.obs;
  RxBool isLoading = false.obs;
  Timer? _timer;

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
    if (sourceScreen == 'forgotpassword') {
      appLog('OtpVerificationController: Resending forgot password OTP');
      final response = await _authRepository.resendForgotPasswordOtp();
      if (response != null && response.isSuccess) {
        AppSnackBar.showSuccess('OTP sent successfully');
      }
    } else if (email.isNotEmpty) {
      appLog('OtpVerificationController: Resending OTP to $email');
      final response = await _authRepository.resendOtp(email: email);
      if (response != null && response.isSuccess) {
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

    // try {
    ckAuth.verifyOtp(otp: otp);

    //   if (result.isSuccess) {
    //     appLog('OtpVerificationController: OTP verified successfully');
    //     AppSnackBar.showSuccess('OTP verified successfully!');
    //     if (sourceScreen == 'forgotpassword') {
    //       Get.offNamed(
    //         AppRoute.changePasswrodScreen,
    //         arguments: {'isForgetPassword': true},
    //       );
    //     }
    //   } else {
    //     appLog(
    //       'OtpVerificationController: Verification failed - ${result.message}',
    //     );
    //     AppSnackBar.showError(result.message ?? 'Verification failed');
    //   }
    // } catch (e) {
    //   appLog('OtpVerificationController: Exception - $e');
    //   AppSnackBar.showError('Something went wrong. Please try again.');
    // } finally {
    isLoading.value = false;
    // }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
