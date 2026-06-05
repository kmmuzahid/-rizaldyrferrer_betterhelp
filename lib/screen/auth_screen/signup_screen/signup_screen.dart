import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/screen/auth_screen/signup_screen/controller/singup_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends GetView<SingupScreenController> {
  const SignupScreen({super.key});

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
              Gap(height: AppSize.height(value: 50)),
              AppText(
                text: AppString.createAccount,
                fontSize: AppSize.width(value: 40),
                lineHeight: 1,
                fontFamilyIndex: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
              Gap(height: AppSize.height(value: 12)),
              AppText(
                text: AppString.pleaseEnterYourMailandPassword,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 18),
                color: AppColors.grey400,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: AppSize.height(value: 30)),
              //! Full Name Field
              AppText(
                text: AppString.fullName,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: AppSize.height(value: 03)),
              AppTextInput(
                controller: controller.fullNameController,
                hintText: AppString.hintFullName,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.name,
              ),
              //! Email Address Field
              Gap(height: AppSize.height(value: 12)),
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
              //! Password Field
              Gap(height: AppSize.height(value: 12)),
              AppText(
                text: AppString.password,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: AppSize.height(value: 03)),
              AppTextInput(
                controller: controller.passwordController,
                hintText: AppString.hintPassword,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              //! Confirm Password Field
              Gap(height: AppSize.height(value: 12)),
              AppText(
                text: AppString.confirmPassword,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: AppSize.height(value: 03)),
              AppTextInput(
                controller: controller.confirmPasswordController,
                hintText: AppString.hintPassword,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
              ),

              //! Sign Up Button
              Gap(height: AppSize.height(value: 20)),
              ckAuth.loadingUi(
                type: .signUp,
                builder: (loading) {
                  return AppButton(
                    title: loading ? "Loading..." : AppString.signUp,
                    backgroundColor: AppColors.primary500,
                    titleColor: AppColors.white,
                    onTap: loading ? null : () => controller.signUp(),
                  );
                },
              ),
              Gap(height: AppSize.height(value: 40)),
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
                  Gap(width: AppSize.width(value: 05)),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.toNamed(AppRoute.loginScreen);
                    },
                    child: AppText(
                      text: AppString.login,
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
