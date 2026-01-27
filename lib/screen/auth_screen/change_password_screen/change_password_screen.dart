import 'package:better_help/screen/auth_screen/change_password_screen/controller/change_password_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordScreenController());

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
                text: AppString.changePassword,
                fontSize: AppSize.width(value: 35),
                lineHeight: 1,
                fontFamilyIndex: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
              Gap(height: AppSize.height(value: 12)),
              AppText(
                text: AppString.writeyourNewPassword,
                fontFamilyIndex: 2,
                fontWeight: FontWeight.w500,
                fontSize: AppSize.width(value: 18),
                color: AppColors.grey400,
                maxLines: 3,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: AppSize.height(value: 30)),
              //! Set Password
              AppText(
                text: 'Current Password',
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: AppSize.height(value: 05)),
              AppTextInput(
                controller: controller.currentPasswordController,
                hintText: "Enter new password",
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              //! Confirm Password
              Gap(height: AppSize.height(value: 20)),
              AppText(
                text: 'New Password',
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: AppSize.height(value: 05)),
              AppTextInput(
                controller: controller.newPasswordController,
                hintText: "Confirm new password",
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              Gap(height: AppSize.height(value: 50)),
              Obx(
                () => AppButton(
                  title: controller.isLoading.value
                      ? "Changing..."
                      : AppString.changePassword,
                  backgroundColor: AppColors.primary500,
                  titleColor: AppColors.white,
                  onTap: controller.isLoading.value
                      ? null
                      : () => controller.changePassword(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
