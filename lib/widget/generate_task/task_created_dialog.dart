import 'package:better_help/screen/habits_sections/main_habits/controller/habits_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCreatedDialog extends StatelessWidget {
  const TaskCreatedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 24),
          vertical: AppSize.height(value: 32),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.width(value: 16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CkImage(
              src: AppStaticImages.success_icon,
              size: 80,
              fill: BoxFit.contain,
            ),
            Gap(height: AppSize.height(value: 20)),
            AppText(
              text: "Task Created!",
              fontFamilyIndex: 1, // Playfair Display
              fontSize: AppSize.width(value: 24),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF131927),
            ),
            Gap(height: AppSize.height(value: 12)),
            AppText(
              text: "Your task has been successfully generated.",
              fontFamilyIndex: 2, // Inter
              fontSize: AppSize.width(value: 14),
              maxLines: 2,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF131927),
              textAlign: TextAlign.center,
            ),
            Gap(height: AppSize.height(value: 32)),
            CkButton(
              titleText: "Go to Home",
              buttonColor: AppColors.primary500,
              onTap: () {
                Get.find<HabitsScreenController>().refreshTasks();
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
