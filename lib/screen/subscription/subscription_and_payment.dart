import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SubscriptionAndPayment extends StatelessWidget {
  const SubscriptionAndPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SubscriptionAndPaymentController(),
      tag: 'subscription',
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height: AppSize.height(value: 15)),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: AppText(
                    text: AppString.skip,
                    fontSize: AppSize.width(value: 20),
                    color: AppColors.blue500,
                    decoration: TextDecoration.underline,
                    lineHeight: 0.80,
                    fontWeight: FontWeight.w600,
                    fontFamilyIndex: 3,
                  ),
                ),
              ),
              Gap(height: AppSize.height(value: 15)),
              AppText(
                text: AppString.enrollment,
                fontSize: AppSize.width(value: 36),
                lineHeight: 1.06,
                color: AppColors.subscriptionTitleText,
                fontWeight: FontWeight.w800,
              ),
              Gap(height: AppSize.height(value: 16)),
              AppText(
                text: AppString.unlockAllThePower,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: AppColors.darkGrey,
                fontSize: AppSize.width(value: 16),
                lineHeight: 1.25,
              ),
              Gap(height: AppSize.height(value: 24)),
              // PageView
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    SingleChildScrollView(child: momentum(controller)),
                    SingleChildScrollView(child: accelerate(controller)),
                    SingleChildScrollView(child: elevate(controller)),
                    SingleChildScrollView(child: ignite(controller)),
                  ],
                ),
              ),

              Gap(height: AppSize.height(value: 20)),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.totalPages,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: controller.currentPageIndex.value == index
                          ? 20
                          : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentPageIndex.value == index
                            ? AppColors.t3
                            : AppColors.grey500.withValues(alpha: 0.3),
                        borderRadius: controller.currentPageIndex.value == index
                            ? BorderRadius.circular(6)
                            : BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
              // // Navigation Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Obx(
              //       () => controller.currentPageIndex.value > 0
              //           ? GestureDetector(
              //               onTap: controller.previousPage,
              //               child: AppText(
              //                 text: 'Previous',
              //                 color: AppColors.blue500,
              //                 fontSize: AppSize.width(value: 16),
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             )
              //           : const SizedBox(width: 80),
              //     ),

              //     Obx(
              //       () =>
              //           controller.currentPageIndex.value <
              //               controller.totalPages - 1
              //           ? GestureDetector(
              //               onTap: controller.nextPage,
              //               child: AppText(
              //                 text: 'Next',
              //                 color: AppColors.blue500,
              //                 fontSize: AppSize.width(value: 16),
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             )
              //           : const SizedBox(width: 80),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget momentum(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.momentumBg,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription01,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.momentum,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 08)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.blue500,
          titleColor: AppColors.white,
        ),
      ],
    ),
  ),
);

Widget accelerate(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.accelerationBg,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription02,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.acceleration,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 10)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.accelerationButton,
          titleColor: AppColors.white,
        ),
      ],
    ),
  ),
);

Widget elevate(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.elevate,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription03,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.elevate,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 10)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.elevateButton,
          titleColor: AppColors.white,
        ),
      ],
    ),
  ),
);

Widget ignite(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.igniteBg,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription03,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.elevate,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 10)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.igniteButton,
          titleColor: AppColors.black,
        ),
      ],
    ),
  ),
);
