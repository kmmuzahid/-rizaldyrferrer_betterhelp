import 'dart:ui';

import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/generate_task/generate_task_dialog.dart';
import 'package:core_kit/snackbar/ck_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> generalSettingsIcons = [
      AppIcons.profileIcons,
      AppIcons.savedArticle,
      AppIcons.favoriteCourse,
      AppIcons.bookings,
    ];
    List<String> generalSettingTitle = [
      "Profile",
      "Saved Articles",
      "Favorite Courses",
      "Bookings",
    ];
    List<String> generalSettingsPage = [
      AppRoute.myProfileScreen,
      AppRoute.savedArticleScreen,
      AppRoute.favriteScreen,
      AppRoute.bookingsSessions,
    ];
    List<String> accountSettingsIcons = [
      // AppIcons.subscriptionLeve,
      AppIcons.mySubscription,
      AppIcons.faqs,
      AppIcons.talkTosupport,
      AppIcons.termsAndConditions,
      AppIcons.privacyPolicy,
    ];
    List<String> accountSettingTitle = [
      // "Subscription Level",
      "My Subscription",
      "FAQs",
      "Talk to Support",
      "Terms and Conditions",
      "Privacy Policy",
    ];
    List<String> accountSettingPage = [
      AppRoute.subscriptionscreen,
      AppRoute.faqsScreen,
      AppRoute.talkToSupportScreen,
      AppRoute.termsAndConditionsScreen,
      AppRoute.privacyPolicyScreen,
    ];
    return SafeArea(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Drawer(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 12),
              vertical: AppSize.height(value: 20),
            ),
            width: MediaQuery.of(context).size.width * 0.75,
            height:
                MediaQuery.of(context).size.height * 0.7, // Set a fixed height
            decoration: BoxDecoration(
              color: const Color(0xFF032F49),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      AppStaticImages.drawerImage,
                      width: AppSize.width(value: 200),
                      height: AppSize.height(value: 75),
                    ),
                  ),
                  Gap(height: 20),
                  AppText(
                    text: "General Settings",
                    color: AppColors.white,
                    fontSize: AppSize.width(value: 14),
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap(height: 10),
                  //! General Settings
                  ...List.generate(generalSettingsIcons.length, (index) {
                    return _generalSetting(
                      generalSettingsPage,
                      index,
                      generalSettingsIcons,
                      generalSettingTitle,
                      () {
                        Get.back();
                        if (index == 3) {
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
                        }
                        Get.toNamed(generalSettingsPage[index]);
                      },
                    );
                  }),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.back();
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
                      Get.dialog(const GenerateTaskDialog());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 20),
                      ),
                      margin: EdgeInsets.only(
                        bottom: AppSize.height(value: 10),
                      ),
                      width: double.infinity,
                      height: AppSize.height(value: 48),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF022134),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.task_outlined, color: Colors.white),
                          Gap(width: 10),
                          AppText(
                            text: "Generate AI tasks",
                            color: AppColors.white,
                            fontFamilyIndex: 2,
                            fontSize: AppSize.width(value: 14),
                            fontWeight: FontWeight.w600,
                          ),
                          Spacer(),
                          SvgPicture.asset(AppIcons.drawerForwart),
                        ],
                      ),
                    ),
                  ),
                  Gap(height: 20),
                  AppText(
                    text: "Account Settings",
                    color: AppColors.white,
                    fontSize: AppSize.width(value: 14),
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                  ),
                  Gap(height: 10),
                  //! Account Settings
                  ...List.generate(accountSettingsIcons.length, (index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Get.back();

                        Get.toNamed(
                          accountSettingPage[index],
                          arguments: {'route_from': "drawer"},
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.width(value: 20),
                        ),
                        margin: EdgeInsets.only(
                          bottom: AppSize.height(value: 10),
                        ),
                        width: double.infinity,
                        height: AppSize.height(value: 48),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF022134),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              accountSettingsIcons[index],
                              // height: AppSize.height(value: 10),
                              // width: AppSize.width(value: 10),
                            ),
                            Gap(width: 10),
                            AppText(
                              text: accountSettingTitle[index],
                              color: AppColors.white,
                              fontFamilyIndex: 2,
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w600,
                            ),
                            Spacer(),
                            SvgPicture.asset(AppIcons.drawerForwart),
                          ],
                        ),
                      ),
                    );
                  }),
                  Gap(height: 40),
                  AppButton(
                    title: "Logout",
                    onTap: () async {
                      await ckAuth.logout();
                    },
                    backgroundColor: AppColors.red500,
                    borderradius: 08,
                  ),
                  Gap(height: 05),
                  Center(
                    child: AppText(
                      text: "Copyright@BetterHabbitsforLife",
                      color: Colors.white,
                      fontSize: AppSize.width(value: 12),
                      fontFamilyIndex: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell _generalSetting(
    List<String> generalSettingsPage,
    int index,
    List<String> generalSettingsIcons,
    List<String> generalSettingTitle,
    void Function() onTap,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        margin: EdgeInsets.only(bottom: AppSize.height(value: 10)),
        width: double.infinity,
        height: AppSize.height(value: 48),
        decoration: ShapeDecoration(
          color: const Color(0xFF022134),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              generalSettingsIcons[index],
              // height: AppSize.height(value: 10),
              // width: AppSize.width(value: 10),
            ),
            Gap(width: 10),
            AppText(
              text: generalSettingTitle[index],
              color: AppColors.white,
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 14),
              fontWeight: FontWeight.w600,
            ),
            Spacer(),
            SvgPicture.asset(AppIcons.drawerForwart),
          ],
        ),
      ),
    );
  }
}
