import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_button/app_button_with_icon.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: 50),
              AppText(
                text: AppString.welcomeBack,
                fontSize: AppSize.width(value: 40),
                lineHeight: 1,
                fontFamilyIndex: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
              Gap(height: 12),
              AppText(
                text: AppString.pleaseEnterYourMailandPassword,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 18),
                color: AppColors.grey400,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: 30),

              //! Email Address Field
              // Gap(height: AppSize.height(value: 12)),
              AppText(
                text: AppString.emailAddress,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              AppTextInput(
                controller: TextEditingController(),
                hintText: AppString.hintEmailAddress,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.emailAddress,
              ),
              //! Password Field
              Gap(height: 12),
              AppText(
                text: AppString.password,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              AppTextInput(
                controller: TextEditingController(),
                hintText: AppString.hintPassword,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.emailAddress,
                isPassword: true,
              ),
              //! Forget Password
              Gap(height: 05),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.toNamed(AppRoute.forgotPasswordScreen);
                  },
                  child: AppText(
                    text: AppString.forgotPassword,
                    color: AppColors.ocean500,
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //! Log In Button
              Gap(height: 20),
              AppButton(
                title: AppString.login,
                backgroundColor: AppColors.primary500,
                titleColor: AppColors.white,
                onTap: () {
                  Get.toNamed(AppRoute.completeProfileScreen);
                },
              ),
              Gap(height: 12),
              Center(child: AppText(text: "Or", fontFamilyIndex: 2)),
              Gap(height: 12),
              //! Google Login
              IconAppButton(
                iconAlignment: CustomIconAlignment.left,
                title: AppString.continueWithGoogle,
                backgroundColor: AppColors.white,
                borderColor: AppColors.borderColor,
                titleColor: AppColors.secondary,
                icon: AppIcons.google,
                onTap: () {},
              ),
              Gap(height: 12),
              //! Apple Login
              IconAppButton(
                iconAlignment: CustomIconAlignment.left,
                title: AppString.continueWithApple,
                backgroundColor: AppColors.white,
                borderColor: AppColors.borderColor,
                titleColor: AppColors.secondary,
                icon: AppIcons.apple,
                onTap: () {},
              ),
              Gap(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: AppString.dontHavaAnAccount,
                    lineHeight: 1.40,
                    letterSpacing: -0.14,
                    fontFamilyIndex: 2,
                    color: AppColors.grey400,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                  ),
                  Gap(width: 05),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.toNamed(AppRoute.signupScreen);
                    },
                    child: AppText(
                      text: AppString.signUp,
                      color: AppColors.secondary,
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w600,
                      lineHeight: 1.40,
                      letterSpacing: -0.14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
