/*
 * @Author: Km Muzahid
 * @Date: 2026-03-01 11:43:48
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PolicyAgreementWidget extends StatelessWidget {
  const PolicyAgreementWidget({super.key, required this.onAgree});
  final Function() onAgree;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppStaticImages.appBarlogo,
              height: AppSize.height(value: 65),
              width: AppSize.width(value: 174),
            ).center,
            CommonText(
              text: 'Privacy & User Agreement',
              style: TextStyle(fontFamily: 'Inter'),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              textColor: AppColors.textPrimaryBlack,
            ),
            CommonText(
              top: 10,
              bottom: 10,
              text: 'We value your privacy. Please read and accept our terms to continue.',
              style: TextStyle(fontFamily: 'Inter'),
              fontSize: 16,
              maxLines: 5,
              textColor: Color(0xff6D717F),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Privacy Policy',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(AppRoute.privacyPolicyScreen);
                      },
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                  TextSpan(
                    text: ' - ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue600,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(AppRoute.termsAndConditionsScreen);
                      },
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1,
                    ),
                  ),
                ],
              ),
            ),
            20.height,
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    titleText: 'Accept',
                    onTap: onAgree,
                    buttonColor: AppColors.primary500,
                    buttonHeight: 48.h,
                  ),
                ),
                10.width,
                Expanded(
                  child: CommonButton(
                    titleText: 'Decline',
                    onTap: () {
                      Get.back();
                    },
                    titleColor: AppColors.darkGrey,
                    buttonColor: Colors.white,
                    borderColor: AppColors.secondary100,
                    buttonHeight: 48.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
