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
    final controller = Get.find<OnboardingScreenController>();

    return Obx(
      () => Scaffold(
        backgroundColor:
            controller.onboardingData[controller.currentPageIndex.value],
        body: SafeArea(
          child: Stack(
            children: [
              // Main content
              Column(
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

                  // PageView
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      children: [
                        onBoadingPage5(),
                        onBoadingPage1(),
                        onBoadingPage2(),
                        onBoadingPage3(),
                        onBoadingPage4(),
                      ],
                    ),
                  ),
                ],
              ),
              // Next button positioned at bottom
              Positioned(
                bottom: AppSize.height(value: 60),
                left: 0,
                right: 0,
                child: Center(
                  child: Obx(
                    () => AppButton(
                      height: AppSize.height(value: 48),
                      width: AppSize.width(value: 160),
                      title:
                          controller.currentPageIndex.value ==
                              controller.totalPages - 1
                          ? AppString.getStarted
                          : AppString.next,
                      titleColor: AppColors.white,
                      backgroundColor: AppColors.blue500,
                      onTap: controller.nextPage,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget onBoadingPage1() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: SizedBox(
    height: AppSize.height(value: 550),
    child: FittedBox(child: Image.asset(AppStaticImages.onboardingGif2)),
  ),
);

Widget onBoadingPage2() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: SizedBox(
    height: AppSize.height(value: 550),
    child: FittedBox(
      fit: BoxFit.contain,
      child: Image.asset(AppStaticImages.onboardingGif3),
    ),
  ),
);

Widget onBoadingPage3() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: SizedBox(
    height: AppSize.height(value: 550),

    child: FittedBox(
      fit: BoxFit.contain,
      child: Image.asset(AppStaticImages.onboardingGif4),
    ),
  ),
);

Widget onBoadingPage4() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: SizedBox(
    height: AppSize.height(value: 550),

    child: FittedBox(
      fit: BoxFit.contain,
      child: Image.asset(AppStaticImages.onboardingGif5),
    ),
  ),
);

Widget onBoadingPage5() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 17),
  child: SizedBox(
    height: AppSize.height(value: 550),
    child: FittedBox(
      fit: BoxFit.contain,
      child: Image.asset(AppStaticImages.onboardingGif1),
    ),
  ),
);
