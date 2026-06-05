import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/corekit_config_impl.dart';
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
import 'package:get/get.dart';

class CompleteProfileScreen extends GetView<EditProfileContrller> {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.lazyPut to prevent multiple instances

    return Scaffold(
      appBar: AppBarWithBack(
        text: "EditComplete Profile",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
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
                child: CkImagePicker(
                  width: 100,
                  height: 100,
                  borderRadius: 16,
                  intialWidget: CkImage(src: '${ckAuth.profile?.profile}'),
                  pickerIconWidget: SvgPicture.asset(
                    AppIcons.completeProfileImageUpload,
                    height: AppSize.height(value: 20),
                    width: AppSize.width(value: 20),
                  ),
                  onChange: (p0) {
                    controller.selectedImage.value = p0;
                  },
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
              ckAuth.loadingUi(
                type: .updateProfile,
                builder: (loading) => AppButton(
                  title: loading ? "Updating..." : "Update Profile",
                  onTap: loading
                      ? null
                      : () {
                          controller.updateProfile();
                        },
                  backgroundColor: AppColors.primary500,
                  titleColor: AppColors.white,
                ),
              ),
              Gap(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
