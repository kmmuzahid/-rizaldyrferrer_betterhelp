import 'dart:ui';

import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySubscriptionScreen extends StatelessWidget {
  const MySubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "My Subscription Screen",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height: 24),
            AppText(
              text: "Current Subscriptions",
              fontSize: AppSize.width(value: 24),

              fontWeight: FontWeight.w800,
              color: Color(0xFF144149),
            ),
            Gap(height: 08),
            AppText(
              text:
                  'Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.',
              fontSize: AppSize.width(value: 14),
              fontFamilyIndex: 2,
              fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
              maxLines: 3,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(height: 12),
            Container(
              height: AppSize.height(value: 276),
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: Colors.white /* Surface-Color-surface-white */,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0xFFEAECF0)),
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0F222C5C),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Momentum",
                        color: const Color(0xFF226D7B),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      AppButton(
                        height: AppSize.height(value: 32),
                        width: AppSize.width(value: 80),
                        backgroundColor: Color(0xFF26CB63),
                        title: "Subscribed",
                        titleColor: AppColors.white,
                        borderradius: 20,
                        fontSize: AppSize.width(value: 10),
                      ),
                    ],
                  ),
                  Gap(height: 08),
                  AppText(
                    text: "First 30 days free - Then \$999/Year",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFD78500),
                  ),
                  Gap(height: 14),
                  AppText(
                    text: "Unlimited Likes",
                    fontSize: 14,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.99,
                    letterSpacing: -0.28,
                  ),
                  Gap(height: 04),
                  AppText(
                    text: 'Unlimited Rewinds',
                    fontSize: 14,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.99,
                    letterSpacing: -0.28,
                  ),
                  Gap(height: 04),
                  AppText(
                    text: "Unlimited Post and Media",
                    fontSize: 14,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.99,
                    letterSpacing: -0.28,
                  ),
                  Gap(height: 04),
                  AppText(
                    text: 'Upload any many as Events',
                    fontSize: 14,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.99,
                    letterSpacing: -0.28,
                  ),
                  Gap(height: 04),
                  AppText(
                    text: 'Unlimited Discounts',
                    fontSize: 14,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.99,
                    letterSpacing: -0.28,
                  ),
                ],
              ),
            ),
            Gap(height: 27),
            AppButton(
              title: "Re-new Subscription",
              backgroundColor: AppColors.primary500,
              titleColor: AppColors.white,
              borderradius: 10,
              onTap: () {},
            ),
            Gap(height: 16),
            AppButton(
              title: "Cancel Subscription",
              backgroundColor: AppColors.white,
              titleColor: Color(0xFFEE443F),
              borderradius: 10,
              borderColor: Color(0xFFEE443F),
              onTap: () {
                cancelSubscription(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> cancelSubscription(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "How Cancellation Works",
                    color: const Color(0xFF144149),
                    fontSize: 24,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  Gap(height: 10),
                  AppText(
                    text: 'See the current subscriptions you are using',
                    color: const Color(0xFF707070),
                    fontSize: 16,
                    fontFamilyIndex: 2,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                        ),
                  Gap(height: 20),
                  _buildStep(
                    icon: AppIcons.mySubscriptionConfirm,
                    title: "Confirm",
                    description:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting",
                  ),
                  Gap(height: 20),
                  _buildStep(
                    icon: AppIcons.mySubscriptionfinished,
                    title: "Write Reason",
                    description:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting",
                  ),
                  Gap(height: 20),
                  _buildStep(
                    icon: AppIcons.mySubscriptionreson,
                    title: "Finishing Cancel Subscriptions",
                    description:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting",
                  ),
                  Gap(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          title: "Cancel",
                          backgroundColor: AppColors.white,
                          titleColor: Color(0xFF707070),
                          borderColor: Color(0xFF707070),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Gap(width: 10),
                      Expanded(
                        child: AppButton(
                          title: "Proceed",
                          backgroundColor: AppColors.primary500,
                          titleColor: AppColors.white,
                          onTap: () {
                            Navigator.of(context).pop();
                            // Add your cancellation logic here
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildStep({
  required String icon,
  required String title,
  required String description,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SvgPicture.asset(icon, width: 24, height: 24),
      Gap(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: title,
              fontSize: 16,
              fontFamilyIndex: 1,
              color: Color(0xFF393939),
              fontWeight: FontWeight.w700,
            ),
            Gap(height: 5),
            AppText(
              text: description,
              fontFamilyIndex: 2,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}
