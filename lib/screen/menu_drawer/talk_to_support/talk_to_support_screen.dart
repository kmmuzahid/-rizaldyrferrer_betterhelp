/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/menu_drawer/talk_to_support/talk_to_support_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class TalkToSupportScreen extends StatelessWidget {
  const TalkToSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TalkToSupportScreenController>();

    return Scaffold(
      appBar: AppBarWithBack(
        text: "Talk to Support",
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
              text: 'Write down the problem you are facing',
              fontSize: AppSize.width(value: 14),
              fontFamilyIndex: 2,
              
              fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
              maxLines: 3,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(height: 12),
            AppTextInput(
              controller: controller.feedbackController,
              maxLines: 15,
              backgroundColor: AppColors.white,
              borderColor: Color(0xFF8F8F8F),
              hintText: "Write your problem here",
            ),
            Gap(height: 15),
            AppButton(
              title: "Send Message", 
              backgroundColor: AppColors.primary500,
              titleColor: AppColors.white,
              onTap: () {
                controller.submitFeedBack(controller.feedbackController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
