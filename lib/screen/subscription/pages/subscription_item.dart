/*
 * @Author: Km Muzahid
 * @Date: 2026-03-01 15:56:54
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:better_help/screen/subscription/model/subscription_model.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:better_help/core/app_route/app_route.dart';

class SubscriptionItem extends StatelessWidget {
  const SubscriptionItem({
    super.key,
    required this.plan,
    required this.controller,
    required this.index,
    required this.totalSubscription,
    this.productDetails,
    required this.duration,
    this.routeFromDrawer = false,
  });
  final SubscriptionModel plan;
  final PageController controller;
  final int index;
  final int totalSubscription;
  final ProductDetails? productDetails;
  final String duration;
  final bool routeFromDrawer;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(int.parse(plan.backgroundColor ?? '00'));
    final buttonTextColor = Color(int.parse(plan.buttonTextColor ?? '00'));
    final buttonColor = Color(int.parse(plan.buttonColor ?? '00'));
    final profileController = Get.find<MyProfileScreenController>();
    return Stack(
      children: [
        Positioned.fill(child: Container(color: backgroundColor)),
        Positioned(
          right: 0,
          top: 0,
          left: 0,
          bottom: 0,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                // App Bar
                20.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: goPreviousPage,
                        child: Container(
                          width: 25,
                          height: 25,
                          padding: EdgeInsets.all(4),
                          color: Colors.transparent,
                          child: SvgPicture.asset(AppIcons.appbarBackIcon),
                        ),
                      ),
                      if (index < totalSubscription)
                        InkWell(
                          onTap: goNextPage,
                          child: AppText(
                            text: AppString.skip,
                            fontFamilyIndex: 3,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            isUnderlined: true,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return _buildFeatureList(
                        index,
                        context,
                        buttonColor,
                        profileController,
                      );
                    },
                    itemCount: (plan.featureList?.length ?? 0) + 5,
                  ),
                ),
                if ((profileController.profileData.value?.subscriptionId ==
                        null ||
                    profileController.profileData.value?.subscriptionId !=
                        plan.id))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        AppButton(
                          titleColor: buttonTextColor,
                          onTap: () {
                            Get.find<SubscriptionAndPaymentController>()
                                .onSubscribe(index - 1);
                          },
                          borderradius: 12,
                          backgroundColor: buttonColor,
                          title: 'Start My Journey',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.find<SubscriptionAndPaymentController>()
                                    .onRestore();
                              },
                              child: AppText(
                                text: 'Restore Purchases',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamilyIndex: 1,
                                color: Colors.black54,
                                isUnderlined: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoute.termsAndConditionsScreen);
                              },
                              child: AppText(
                                text: 'Terms of Use',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamilyIndex: 1,
                                color: Colors.black54,
                                isUnderlined: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            AppText(
                              text: '•',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamilyIndex: 1,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoute.privacyPolicyScreen);
                              },
                              child: AppText(
                                text: 'Privacy Policy',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamilyIndex: 1,
                                color: Colors.black54,
                                isUnderlined: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList(
    int index,
    BuildContext context,
    Color buttonColor,
    MyProfileScreenController profileController,
  ) {
    if (index == 0) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .3,
        ),
        child: CommonImage(src: plan.image ?? '', fill: BoxFit.contain),
      );
    } else if (index == 1) {
      return Row(
        children: [
          AppText(
            text: plan.title ?? '',
            fontFamilyIndex: 1,
            fontSize: 40,
            color: Color(0xff080B10),
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.left,
          ),
          const Spacer(),
          if (plan.id == profileController.profileData.value?.subscriptionId)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(
                  int.parse(plan.buttonTextColor ?? '00'),
                ).withValues(alpha: .9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                text: 'Current Plan',
                fontFamilyIndex: 2,
                fontSize: 16,
                color: Color(int.parse(plan.buttonColor ?? '00')),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      );
    } else if (index == 2) {
      return CommonText(
        text: plan.subtitle ?? '',
        style: GoogleFonts.inter(),
        fontSize: 20,
        textColor: Color(0xff080B10),
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.left,
      );
    } else if (index == 3) {
      final controller = Get.find<SubscriptionAndPaymentController>();
      final product = controller.storeProducts[plan.productId];

      // Use localized price from store
      final String priceText =
          product?.price ??
          (plan.price == 0 ? 'Free' : productDetails?.price ?? '');

      return Row(
        children: [
          AppText(
            text: priceText,
            fontFamilyIndex: 2,
            fontSize: 36,
            color: buttonColor,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
          10.width,
          AppText(
            text: plan.price == 0 ? '/ Lifetime' : '/ $duration',
            fontFamilyIndex: 2,
            fontSize: 18,
            color: Color(0xff61656E),
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ],
      );
    } else if (index == 4) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: List.generate(plan.featureList?.length ?? 0, (index) {
            return _buildFeatureItem(index);
          }),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFeatureItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AppStaticImages.check_02, height: 16, width: 16),
          ),
          Expanded(
            child: AppText(
              text: plan.featureList?[index] ?? "",
              fontFamilyIndex: 2,
              fontSize: 18,
              maxLines: 5,
              color: Color(0xff131927),
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  goNextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  goPreviousPage() {
    if (routeFromDrawer && index == 0) {
      Get.back();
    } else {
      controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
