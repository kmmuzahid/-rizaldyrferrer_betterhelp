/*
 * @Author: Km Muzahid
 * @Date: 2026-03-01 15:38:10
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class SubscriptionInitalPage extends StatelessWidget {
  const SubscriptionInitalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffd0ebfb),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Spacer(),
          AppText(
            text:
                'We’re glad that you’re continuing your journey with us. Choose your subscription level.',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamilyIndex: 1,
            maxLines: 5,
            color: Color(0xff144149),
            textAlign: TextAlign.center,
          ),
          42.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImage(src: AppStaticImages.check_01, size: 16),
              6.width,
              AppText(
                text: 'Better Habits',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamilyIndex: 1,
                maxLines: 5,
                color: Color(0xff144149),
                textAlign: TextAlign.center,
              ),
              38.width,
              CommonImage(src: AppStaticImages.check_01, size: 16),
              6.width,
              AppText(
                text: 'Better Life',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamilyIndex: 1,
                maxLines: 5,
                color: Color(0xff144149),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          100.height,
          CommonButton(
            titleText: 'Learn More',
            buttonWidth: double.infinity,
            buttonRadius: 12,
            buttonHeight: 48,
            buttonColor: AppColors.momentumButton,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
