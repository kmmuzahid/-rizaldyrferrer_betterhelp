import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/auth_screen/complete_profile_screen/controller/complete_profile_contrller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CompleteProfileContrller controller = Get.put(
      CompleteProfileContrller(),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: 30),
              AppText(
                text: AppString.completeYourProfile,
                fontSize: AppSize.width(value: 25),
                lineHeight: 1,
                fontFamilyIndex: 1,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
              Gap(height: 12),
              AppText(
                text: AppString.shareYourpersonaldetails,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                color: AppColors.grey400,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: 20),
              //! Created the profile Images Section
              Center(
                child: Obx(
                  () => InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => controller.pickAndUpdateImage(context),
                    child: Container(
                      height: AppSize.height(value: 100),
                      width: AppSize.width(value: 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                              : const AssetImage(
                                      "assets/images/completeProfile01.png",
                                    )
                                    as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.blue900,
                                strokeWidth: 2,
                              ),
                            )
                          : controller.selectedImage.value == null
                          ? Center(
                              child: SvgPicture.asset(
                                AppIcons.completeProfileImageUpload,
                                height: AppSize.height(value: 25),
                                width: AppSize.width(value: 25),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              Gap(height: 16),
              //! Full Name Field
              AppText(
                text: AppString.fullName,
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
              //! Gender Field
              Gap(height: 08),
              AppText(
                text: AppString.gender,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.selectGender('Male'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSize.height(value: 12),
                            horizontal: AppSize.width(value: 16),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.selectedGender.value == 'Male'
                                  ? AppColors.blue900
                                  : AppColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: controller.selectedGender.value == 'Male'
                                ? AppColors.blue900.withValues(alpha: 0.1)
                                : AppColors.white,
                          ),
                          child: Center(
                            child: AppText(
                              text: 'Male',
                              fontFamilyIndex: 2,
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w500,
                              color: controller.selectedGender.value == 'Male'
                                  ? AppColors.blue900
                                  : AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.selectGender('Female'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSize.height(value: 12),
                            horizontal: AppSize.width(value: 16),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.selectedGender.value == 'Female'
                                  ? AppColors.blue900
                                  : AppColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: controller.selectedGender.value == 'Female'
                                ? AppColors.blue900.withValues(alpha: .1)
                                : AppColors.white,
                          ),
                          child: Center(
                            child: AppText(
                              text: 'Female',
                              fontFamilyIndex: 2,
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w500,
                              color: controller.selectedGender.value == 'Female'
                                  ? AppColors.blue900
                                  : AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //! My Ethnic Descent
              Gap(height: 08),
              AppText(
                text: AppString.myEthnicDecent,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              AppTextInput(
                controller: TextEditingController(),
                hintText: AppString.myEthnicDecent,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.text,
              ),
              Gap(height: 08),
              //! Input Date of Birth
              AppText(
                text: AppString.dateOfBirth,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              AppTextInput(
                controller: TextEditingController(),
                hintText: AppString.dateOfBirth,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.datetime,
              ),
              //! City or Country
              Gap(height: 08),
              AppText(
                text: AppString.cityCountry,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              AppTextInput(
                controller: TextEditingController(),
                hintText: AppString.cityCountry,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.text,
              ),
              //! Address
              Gap(height: 08),
              AppText(
                text: AppString.timeZone,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              Gap(height: 03),
              AppTextInput(
                controller: TextEditingController(),
                hintText: AppString.timeZone,
                borderColor: AppColors.borderColor,
                backgroundColor: AppColors.white,
                keyboardType: TextInputType.text,
              ),
              Gap(height: 20),
              AppButton(
                title: AppString.next,
                onTap: () {
                  Get.toNamed(AppRoute.bottomNav);
                },
                backgroundColor: AppColors.primary500,
                titleColor: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
