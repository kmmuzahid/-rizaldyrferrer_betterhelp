import 'package:better_help/screen/auth_screen/otp_verification_screen/controller/otp_verification_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());
    return Scaffold(
      appBar: AppBarWithBack(text: ''),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: 50),
              AppText(
                text: AppString.otpVerification,
                fontSize: AppSize.width(value: 35),
                lineHeight: 1,
                fontFamilyIndex: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
              Gap(height: 12),
              AppText(
                text: AppString.enterOtp,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 18),
                fontWeight: FontWeight.w500,
                color: AppColors.grey400,
                maxLines: 3,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: 30),
              AppText(
                text: AppString.enterCode,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 3),
              Pinput(
                controller: _controller,
                focusNode: _focusNode,
                mouseCursor: MouseCursor.defer,
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                defaultPinTheme: PinTheme(
                  width: AppSize.width(value: 70),
                  height: AppSize.height(value: 70),
                  textStyle: TextStyle(
                    fontSize: AppSize.width(value: 22),
                    color: AppColors.blue900,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.transparent, width: 1),
                  ),
                ),
                showCursor: true,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: AppSize.width(value: 22),
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.blue900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                preFilledWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: AppSize.width(value: 22),
                      height: 4,
                      decoration: BoxDecoration(
                        color:
                            AppColors.grey400, // Subtle color for empty fields
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                onCompleted: (pin) {
                  // Handle OTP submission
                  appLog('OTP entered: $pin');
                  controller.verifyOtp(pin);
                },
              ),
              Gap(height: 30),
              Center(
                child: AppText(
                  text: AppString.aCodehasbeenSent,
                  fontFamilyIndex: 2,
                  fontSize: AppSize.width(value: 14),
                  color: AppColors.grey400,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(height: 20),
              Center(
                child: CkAuth.otpCountdownUi(
                  builder: (count) {
                    return count > 0
                        ? AppText(
                            text: "${AppString.resendin} ${count}s",
                            fontFamilyIndex: 2,
                            fontSize: AppSize.width(value: 16),
                            color: AppColors.grey400,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                          )
                        : GestureDetector(
                            onTap: controller.resetTimer,
                            child: AppText(
                              text: "Resend Code",
                              fontFamilyIndex: 2,
                              fontSize: AppSize.width(value: 16),
                              color: AppColors.blue900,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          );
                  },
                ),
              ),
              // Center(
              //   child: Obx(
              //     () => controller.isTimerActive.value
              //         ? AppText(
              //             text:
              //                 "${AppString.resendin} ${controller.timerSeconds.value}s",
              //             fontFamilyIndex: 2,
              //             fontSize: AppSize.width(value: 16),
              //             color: AppColors.grey400,
              //             maxLines: 3,
              //             textAlign: TextAlign.center,
              //             overflow: TextOverflow.ellipsis,
              //             fontWeight: FontWeight.w500,
              //           )
              //         : GestureDetector(
              //             onTap: controller.resetTimer,
              //             child: AppText(
              //               text: "Resend Code",
              //               fontFamilyIndex: 2,
              //               fontSize: AppSize.width(value: 16),
              //               color: AppColors.blue900,
              //               maxLines: 3,
              //               textAlign: TextAlign.center,
              //               overflow: TextOverflow.ellipsis,
              //               fontWeight: FontWeight.w600,
              //               decoration: TextDecoration.underline,
              //             ),
              //           ),
              //   ),
              // ),
              //! Verify Otp Button
              Gap(height: 30),
              CkAuth.loadingUi(
                type: .verifyOtp,
                builder: (loading) {
                  return AppButton(
                    title: AppString.verify,
                    isLoading: loading,
                    onTap: loading
                        ? null
                        : () => controller.verifyOtp(_controller.text),
                    backgroundColor: AppColors.primary500,
                    titleColor: AppColors.white,
                  );
                },
              ),
              Gap(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
