import 'dart:io';

import 'package:better_help/screen/menu_drawer/my_profile/edit_profile_screen/controller/edit_profile_contrller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CompleteProfileScreen extends GetView<EditProfileContrller> {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.lazyPut to prevent multiple instances

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Clean up controller when leaving screen
        Get.delete<EditProfileContrller>();
      },
      child: Scaffold(
        appBar: AppBarWithBack(
          text: "EditComplete Profile",
          backgroundColor: AppColors.white,
        ),
        backgroundColor: AppColors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(height: 30),
                  AppText(
                    text: "Edit Your Profile",
                    fontSize: AppSize.width(value: 25),
                    lineHeight: 1,
                    fontFamilyIndex: 1,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue900,
                  ),
                  Gap(height: 12),
                  AppText(
                    text: "Update your personal details",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 14),
                    color: AppColors.grey400,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(height: 20),
                  //! Profile Image Section
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
                                  ? FileImage(
                                      File(
                                        controller.selectedImage.value!.path,
                                      ),
                                    )
                                  : (controller.profileData.value?.profile !=
                                                null &&
                                            controller
                                                .profileData
                                                .value!
                                                .profile!
                                                .isNotEmpty
                                        ? NetworkImage(
                                            '${controller.profileData.value!.profile}',
                                          )
                                        : const AssetImage(
                                                "assets/images/completeProfile01.png",
                                              )
                                              as ImageProvider),
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
                              : Center(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      AppIcons.completeProfileImageUpload,
                                      height: AppSize.height(value: 20),
                                      width: AppSize.width(value: 20),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Gap(height: 16),
                  //! Full Name Field
                  AppText(
                    text: "Full Name",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                  Gap(height: 03),
                  AppTextInput(
                    controller: controller.fullNameController,
                    hintText: "Enter your full name",
                    borderColor: AppColors.borderColor,
                    backgroundColor: AppColors.white,
                    keyboardType: TextInputType.name,
                  ),
                  Gap(height: 08),
                  //! Phone Field
                  AppText(
                    text: "Phone Number",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                  Gap(height: 03),
                  AppTextInput(
                    controller: controller.phoneController,
                    hintText: "Enter your phone number",
                    borderColor: AppColors.borderColor,
                    backgroundColor: AppColors.white,
                    keyboardType: TextInputType.phone,
                  ),
                  Gap(height: 08),
                  //! Address Field
                  AppText(
                    text: "Address",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                  Gap(height: 03),
                  AppTextInput(
                    controller: controller.addressController,
                    hintText: "Enter your address",
                    borderColor: AppColors.borderColor,
                    backgroundColor: AppColors.white,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  Gap(height: 20),
                  Obx(
                    () => AppButton(
                      title: controller.isSaving.value
                          ? "Updating..."
                          : "Update Profile",
                      onTap: controller.isSaving.value
                          ? null
                          : () => controller.updateProfile(),
                      backgroundColor: AppColors.primary500,
                      titleColor: AppColors.white,
                    ),
                  ),
                  Gap(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
