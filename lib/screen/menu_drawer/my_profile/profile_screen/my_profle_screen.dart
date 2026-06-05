import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_size/app_gap.dart';
import '../../../../widget/app_appbar/app_back_appbar.dart';

class MyProfleScreen extends GetView<MyProfileScreenController> {
  const MyProfleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(text: "Profile", backgroundColor: AppColors.white),
      backgroundColor: AppColors.white,
      body: ckAuth.profileUi(
        builder: (_, profile) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(height: AppSize.height(value: 24)),
                  Center(
                    child: CkImage(
                      borderRadius: 12,
                      src: profile?.profile ?? '',
                      height: AppSize.height(value: 100),
                      width: AppSize.width(value: 100),
                      fill: BoxFit.cover,
                    ),
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Center(
                    child: AppText(
                      text: profile?.fullName ?? "User Name",
                      color: AppColors.black,
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(height: AppSize.height(value: 12)),
                  Center(
                    child: AppButton(
                      title: profile?.isSubscribed == true
                          ? "Subscribed"
                          : "Elevete Subscribe",
                      fontSize: AppSize.width(value: 14),
                      width: AppSize.width(value: 150),
                      height: AppSize.height(value: 36),
                      borderradius: 12,
                      backgroundColor: Color(0xFF0A7BFF),
                    ),
                  ),
                  Gap(height: AppSize.height(value: 12)),
                  AppText(
                    text: "Personal Information",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                  ),
                  Gap(height: AppSize.height(value: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Phone : ",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                      AppText(
                        text: profile?.phone ?? "N/A",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Divider(height: 0.3, color: AppColors.grey400),
                  Gap(height: AppSize.height(value: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Address : ",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                      Expanded(
                        child: AppText(
                          text: profile?.address ?? "N/A",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Divider(height: 0.3, color: AppColors.grey400),
                  Gap(height: AppSize.height(value: 12)),
                  AppText(
                    text: "General Information",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                  ),
                  Gap(height: AppSize.height(value: 12)),
                  Row(
                    children: [
                      AppText(
                        text: "Email Address : ",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                      Expanded(
                        child: AppText(
                          text: profile?.email ?? "N/A",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Divider(height: 0.3, color: AppColors.grey400),
                  Gap(height: AppSize.height(value: 12)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Change Password : ",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.changePasswrodScreen);
                        },
                        child: AppText(
                          text: "Click here",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Divider(height: 0.3, color: AppColors.grey400),
                  Gap(height: AppSize.height(value: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Request to Reassing BHA/BHAA",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                      GestureDetector(
                        onTap: () {
                          MyProfileScreenController myProfileScreenController =
                              Get.find<MyProfileScreenController>();
                          if (myProfileScreenController
                                      .profileData
                                      .value
                                      ?.subscriptionPlanType ==
                                  'free' ||
                              myProfileScreenController
                                      .profileData
                                      .value
                                      ?.subscriptionPlanType ==
                                  null) {
                            CkSnackBar('Upgrade Your Plan', type: .warning);
                            return;
                          }
                          showReplaceBhaBhaaDialog();
                        },
                        child: AppText(
                          text: "Click here",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Divider(height: 0.3, color: AppColors.grey400),
                  Gap(height: AppSize.height(value: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Delete Account : ",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                      AppText(
                        text: "Delete",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.red500,
                        decoration: TextDecoration.underline,
                      ),
                    ],
                  ),
                  Gap(height: AppSize.height(value: 08)),
                  Divider(height: 0.3, color: AppColors.grey400),
                  Gap(height: AppSize.height(value: 25)),
                  //! Edit Profile Button
                  AppButton(
                    title: "Edit Profile",
                    backgroundColor: AppColors.primary500,
                    fontSize: AppSize.width(value: 16),
                    height: AppSize.height(value: 40),
                    borderradius: 12,
                    onTap: () {
                      Get.toNamed(AppRoute.completeProfileScreen);
                    },
                  ),
                  Gap(height: AppSize.height(value: 50)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showReplaceBhaBhaaDialog() {
    final RxString selectedChoice = 'BHA'.obs;
    final RxString reason = ''.obs;

    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 15,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reassign Role",
                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
              ),

              const SizedBox(height: 10),

              CkDropDown(
                enableInitalSelection: true,
                hint: "Select BHA/BHAA",
                items: ["BHA", "BHAA"],
                onChanged: (value) {
                  selectedChoice.value = value ?? 'BHA';
                },
                nameBuilder: (item) => CkText(text: item.item),
              ),

              const SizedBox(height: 16),

              const CkText(
                text: 'Write down the reason for changing BHA, BHAA',
                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: AppSize.height(value: 140),
                child: CkMultilineTextField(
                  hintText: "Reason",
                  validationType: CkValidationType.validateRequired,
                  onChanged: (value) {
                    reason.value = value;
                  },
                ),
              ),

              20.height,

              Obx(() {
                return CkButton(
                  isLoading: controller.isReplaceBhaBhaaLoading.value,
                  buttonRadius: 8,
                  buttonColor: Colors.cyan,
                  titleColor: Colors.white,
                  buttonWidth: double.infinity,

                  onTap: () async {
                    if (reason.value.trim().isEmpty) {
                      AppSnackBar.showWarning("Please enter reason");
                      return;
                    }

                    await controller.replaceBhaBhaa(
                      choice: selectedChoice.value,
                      reason: reason.value,
                    );

                    Navigator.pop(context);
                  },

                  titleText: "Send Request",
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
