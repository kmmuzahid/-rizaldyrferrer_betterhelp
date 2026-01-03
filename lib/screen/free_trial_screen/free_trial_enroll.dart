import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/app_route/app_route.dart';
import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_icons/app_icons.dart';
import '../../utils/app_images/app_images.dart';
import '../../utils/app_size/app_gap.dart';

class FreeTrialEnrollScreen extends StatelessWidget {
  const FreeTrialEnrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              Color(0xFFADECE8).withValues(alpha: 0.5),
              // teal shade in center
              AppColors.white, // fades to white
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            child: Column(
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
                Gap(height: AppSize.height(value: 125)),
                AppText(
                  text:
                      "Begin your Better Habits journey and enjoy your first 14 days free.",
                  fontFamilyIndex: 2,
                  fontSize: AppSize.width(value: 36),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey500,
                  maxLines: 5,
                ),
                Gap(height: AppSize.height(value: 25)),
                AppButton(
                  onTap: () {
                    Get.toNamed(AppRoute.signupScreen);
                  },
                  title: "Enroll Now",
                  backgroundColor: AppColors.primary500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
