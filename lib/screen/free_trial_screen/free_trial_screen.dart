import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_icons/app_icons.dart';
import '../../utils/app_images/app_images.dart';
import '../../utils/app_size/app_gap.dart';

class FreeTrialScreen extends StatelessWidget {
  const FreeTrialScreen({super.key});

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
              Gap(height: AppSize.height(value: 35)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(AppIcons.appbarBackIcon),
                    ),
                    Gap(width: AppSize.width(value: 60)),
                    Image.asset(
                      AppStaticImages.appBarlogo,
                      height: AppSize.height(value: 65),
                      width: AppSize.width(value: 174),
                    ),
                  ],
                ),
              ),

              //Content of Page
              Gap(height: AppSize.height(value: 35)),
              AppText(
                text: "Personalized Insight Summary",
                fontFamilyIndex: 1,
                fontSize: AppSize.width(value: 22),
                fontWeight: FontWeight.w700,
                color: AppColors.grey500,
              ),
              AppText(
                text:
                    "Thank you for completing the questionnaire. Your responses suggest that you often experience difficulty with focus, organization, and follow-through-core parts of self-management linked to executive functioning.",
                maxLines: 5,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                color: AppColors.grey400,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(height: AppSize.height(value: 20)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 12),
                  vertical: AppSize.height(value: 10),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(08),
                ),
                child: Column(
                  children: [
                    AppText(
                      text: "Here's how Better Habits for Life can help:",
                      fontFamilyIndex: 2,
                      fontSize: AppSize.height(value: 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryBlack,
                    ),
                    Gap(height: AppSize.height(value: 12)),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.freeTrialScreenCheck,
                          height: AppSize.height(value: 18),
                          width: AppSize.width(value: 18),
                        ),
                        Gap(width: AppSize.width(value: 08)),
                        AppText(
                          text: "Learn methods that help",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Gap(height: AppSize.height(value: 16)),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.freeTrialScreenCheck,
                          height: AppSize.height(value: 18),
                          width: AppSize.width(value: 18),
                        ),
                        Gap(width: AppSize.width(value: 08)),
                        AppText(
                          text: "Build daily routines that help",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Gap(height: AppSize.height(value: 16)),

                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.freeTrialScreenCheck,
                          height: AppSize.height(value: 18),
                          width: AppSize.width(value: 18),
                        ),
                        Gap(width: AppSize.width(value: 08)),
                        AppText(
                          text: "Receive reminders to help you",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(height: AppSize.height(value: 32)),
              AppButton(
                title: "Join for a 14-Day Free Trial",
                backgroundColor: AppColors.primary500,
                onTap: () {
                  Get.toNamed(AppRoute.freeTrialEnrollScreen);
                },
              ),
              Gap(height: AppSize.height(value: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
