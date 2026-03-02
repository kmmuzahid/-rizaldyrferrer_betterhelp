/*
 * @Author: Km Muzahid
 * @Date: 2026-03-01 15:56:54
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:better_help/screen/subscription/model/subscription_plan.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionItem extends StatelessWidget {
  const SubscriptionItem({
    super.key,
    required this.plan,
    required this.controller,
    required this.index,
    required this.totalSubscription,
  });
  final SubscriptionPlan plan;
  final PageController controller;
  final int index;
  final int totalSubscription;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: plan.backgroundColor)),
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
                          color: plan.backgroundColor,
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
                            color: AppColors.textPrimaryBlack,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return _buildFeatureList(index, context);
                    },
                    itemCount: plan.featureList.length + 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppButton(
                    titleColor: plan.buttonTextColor,
                    onTap: () {
                      Get.find<SubscriptionAndPaymentController>().onSubscribe(index - 1);
                    },
                    borderradius: 12,
                    backgroundColor: plan.buttonColor,
                    title: 'Start My Journey',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList(int index, BuildContext context) {
    if (index == 0) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .3),
        child: CommonImage(src: plan.image, fill: BoxFit.contain),
      );
    } else if (index == 1) {
      return AppText(
        text: plan.title,
        fontFamilyIndex: 1,
        fontSize: 40,
        color: Color(0xff080B10),
        fontWeight: FontWeight.w500,
        textAlign: TextAlign.left,
      );
    } else if (index == 2) {
      return CommonText(
        text: plan.subtitle,
        style: GoogleFonts.inter(),
        fontSize: 20,
        textColor: Color(0xff080B10),
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.left,
      );
    } else if (index == 3) {
      return Row(
        children: [
          Text(
            '\$447',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff6D717F),
              decoration: TextDecoration.lineThrough,
              decorationColor: Color(0xff032F49),
              decorationThickness: 2,
            ),
          ),
          10.width,
          AppText(
            text: '\$199',
            fontFamilyIndex: 2,
            fontSize: 36,
            color: plan.buttonColor,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
          10.width,
          AppText(
            text: '/ First 3 months',
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
          children: List.generate(plan.featureList.length, (index) {
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
              text: plan.featureList[index],
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
    controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goPreviousPage() {
    controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
