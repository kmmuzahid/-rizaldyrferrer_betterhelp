import 'package:better_help/screen/onboarding_screen/controller/onboarding_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OnbardingScreen extends StatelessWidget {
  const OnbardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingScreenController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Gap(height: AppSize.height(value: 32)),
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => InkWell(
                      onTap: controller.currentPageIndex.value > 0
                          ? controller.previousPage
                          : null,
                      child: Opacity(
                        opacity: controller.currentPageIndex.value > 0
                            ? 1.0
                            : 0.3,
                        child: SvgPicture.asset(AppIcons.appbarBackIcon),
                      ),
                    ),
                  ),
                  Image.asset(
                    AppStaticImages.appBarlogo,
                    height: AppSize.height(value: 65),
                    width: AppSize.width(value: 174),
                  ),
                  InkWell(
                    onTap: controller.skipOnboarding,
                    child: AppText(
                      text: AppString.skip,
                      fontFamilyIndex: 3,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      isUnderlined: true,
                      color: AppColors.textPrimaryBlack,
                    ),
                  ),
                ],
              ),
            ),
            Gap(height: AppSize.height(value: 20)),

            // PageView
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  onBoadingPage1(),
                  onBoadingPage2(),
                  onBoadingPage3(),
                  onBoadingPage4(),
                  onBoadingPage5(),
                ],
              ),
            ),
            Gap(height: AppSize.height(value: 20)),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 56, right: 20, left: 20),
        child: Obx(
          () => AppButton(
            title:
                controller.currentPageIndex.value == controller.totalPages - 1
                ? AppString.getStarted
                : AppString.next,
            titleColor: AppColors.white,
            backgroundColor: AppColors.blue500,
            onTap: controller.nextPage,
          ),
        ),
      ),
    );
  }
}

Widget onBoadingPage1() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: Container(
    height: AppSize.height(value: 650),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(35),
    ),
    child: Image.asset(AppStaticImages.onboardingGif1, fit: BoxFit.contain),
  ),
  /*  Column(
    children: [
      Image.asset(
        AppStaticImages.on01,
        width: AppSize.width(value: 326),
        height: AppSize.height(value: 356),
      ),
      Gap(height: AppSize.height(value: 32)),
      AppText(
        text: AppString.onPage1Title,
        fontSize: AppSize.width(value: 24),
        fontFamilyIndex: 2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.24,
        lineHeight: 1.33,
        color: AppColors.grey500,
      ),
      Gap(height: AppSize.height(value: 12)),
      AppText(
        text: AppString.onPage1Subtitle,
        color: AppColors.textMain,
        fontFamilyIndex: 2,
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w500,
        lineHeight: 1.5,
        maxLines: 2,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ), */
);

Widget onBoadingPage2() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: Container(
    height: AppSize.height(value: 650),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(35),
    ),
    child: Image.asset(AppStaticImages.onboardingGif2, fit: BoxFit.contain),
  ),
  /*
   olumn(
    children: [
      Image.asset(
        AppStaticImages.on02,
        width: AppSize.width(value: 326),
        height: AppSize.height(value: 356),
      ),
      Gap(height: AppSize.height(value: 32)),
      AppText(
        text: AppString.onPage2Title,
        fontSize: AppSize.width(value: 24),
        fontFamilyIndex: 2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.24,
        lineHeight: 1.33,
        color: AppColors.grey500,
      ),
      Gap(height: AppSize.height(value: 12)),
      AppText(
        text: AppString.onPage2Subtitle,
        color: AppColors.textMain,
        fontFamilyIndex: 2,
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w500,
        lineHeight: 1.5,
        maxLines: 3,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
   */
);
Widget onBoadingPage3() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: Container(
    height: AppSize.height(value: 650),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(35),
    ),
    child: Image.asset(AppStaticImages.onboardingGif3, fit: BoxFit.contain),
  ),
  /* Column(
    children: [
      Image.asset(
        AppStaticImages.on03,
        width: AppSize.width(value: 326),
        height: AppSize.height(value: 356),
      ),
      Gap(height: AppSize.height(value: 32)),
      AppText(
        text: AppString.onPage3Title,
        fontSize: AppSize.width(value: 24),
        fontFamilyIndex: 2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.24,
        lineHeight: 1.33,
        color: AppColors.grey500,
      ),
      Gap(height: AppSize.height(value: 12)),
      AppText(
        text: AppString.onPage3Subtitle,
        color: AppColors.textMain,
        fontFamilyIndex: 2,
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w500,
        lineHeight: 1.5,
        maxLines: 2,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
   */
);

Widget onBoadingPage4() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: Container(
    height: AppSize.height(value: 650),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(35),
    ),
    child: Image.asset(AppStaticImages.onboardingGif4, fit: BoxFit.contain),
  ),
  /* Column(
    children: [
      Image.asset(
        AppStaticImages.on04,
        width: AppSize.width(value: 326),
        height: AppSize.height(value: 356),
      ),
      Gap(height: AppSize.height(value: 32)),
      AppText(
        text: AppString.onPage4Title,
        fontSize: AppSize.width(value: 24),
        fontFamilyIndex: 2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.24,
        lineHeight: 1.33,
        color: AppColors.grey500,
      ),
      Gap(height: AppSize.height(value: 12)),
      AppText(
        text: AppString.onPage4Subtitle,
        color: AppColors.textMain,
        fontFamilyIndex: 2,
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w500,
        lineHeight: 1.5,
        maxLines: 2,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ), */
);

Widget onBoadingPage5() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: Container(
    height: AppSize.height(value: 650),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(35),
    ),
    child: Image.asset(AppStaticImages.onboardingGif5, fit: BoxFit.contain),
  ),
  /* Column(
    children: [
      Image.asset(
        AppStaticImages.on05,
        width: AppSize.width(value: 326),
        height: AppSize.height(value: 356),
      ),
      Gap(height: AppSize.height(value: 32)),
      AppText(
        text: AppString.onPage5Title,
        fontSize: AppSize.width(value: 24),
        fontFamilyIndex: 2,
        fontWeight: FontWeight.w600,
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        letterSpacing: 0.24,
        lineHeight: 1.33,
        color: AppColors.grey500,
      ),
      Gap(height: AppSize.height(value: 12)),
      AppText(
        text: AppString.onPage5Subtitle,
        color: AppColors.textMain,
        fontFamilyIndex: 2,
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w500,
        lineHeight: 1.5,
        letterSpacing: 0.16,
        maxLines: 3,
        textAlign: TextAlign.justify,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ), */
);
