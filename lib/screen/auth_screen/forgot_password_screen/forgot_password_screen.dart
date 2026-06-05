/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/auth_screen/forgot_password_screen/controller/forgot_password_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordScreenController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWithBack(text: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: AppSize.height(value: 50)),
              AppText(
                text: AppString.forgotPassword,
                fontSize: AppSize.width(value: 35),
                lineHeight: 1,
                fontFamilyIndex: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
              Gap(height: AppSize.height(value: 12)),
              AppText(
                text: AppString.enterYouremailAddressToSendYou,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 18),
                color: AppColors.grey400,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: AppSize.height(value: 30)),
              //! Email Address Field
              AppText(
                text: AppString.emailAddress,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: AppSize.height(value: 03)),
              AppTextInput(
                controller: controller.emailController,
                hintText: AppString.hintEmailAddress,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.emailAddress,
              ),
              Gap(height: AppSize.height(value: 30)),
              //! Send Code
              CkAuth.loadingUi(
                type: .forgotPassword,
                builder: (loading) => AppButton(
                  title: loading ? "Sending..." : AppString.sendCode,
                  backgroundColor: AppColors.primary500,
                  titleColor: AppColors.white,
                  onTap: loading ? null : () => controller.sendCode(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
