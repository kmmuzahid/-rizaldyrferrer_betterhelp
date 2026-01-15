import 'package:better_help/screen/community_sections/creating_post/controller/creating_post_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatingPostScreen extends StatelessWidget {
  const CreatingPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreatingPostController>();
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Create Post",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height: 20),
            AppText(
              text: 'Title',
              color: Colors.black,
              fontSize: 14,
              fontFamilyIndex: 2,
              fontWeight: FontWeight.w500,
            ),
            AppTextInput(
              controller: controller.titleController,
              textColor: AppColors.white900,
              backgroundColor: AppColors.white,
              hintText: 'Enter title',
              hintTextColor: AppColors.white900,
              borderRadius: 10,
              borderColor: AppColors.habitsCalendarBorder,
            ),
            Gap(height: 20),
            AppText(
              text: 'Content',
              color: Colors.black,
              fontSize: 14,
              fontFamilyIndex: 2,
              fontWeight: FontWeight.w500,
            ),
            AppTextInput(
              controller: controller.contentController,
              textColor: AppColors.white900,
              backgroundColor: AppColors.white,
              hintText: 'Enter content',
              hintTextColor: AppColors.white900,
              borderRadius: 10,
              borderColor: AppColors.habitsCalendarBorder,
              maxLines: 10,
            ),
            Gap(height: 20),
            Obx(() {
              return AppButton(
                title: controller.isSubmitting.value
                    ? "Posting..."
                    : "Post Now",
                backgroundColor: AppColors.primary500,
                titleColor: AppColors.white,
                fontSize: AppSize.width(value: 12),
                onTap: controller.isSubmitting.value
                    ? null
                    : () {
                        controller.submitPost();
                      },
              );
            }),
          ],
        ),
      ),
    );
  }
}
