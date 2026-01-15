import 'package:better_help/screen/habits_sections/my_task/controller/my_task_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTaskScreeen extends GetView<MyTaskController> {
  const MyTaskScreeen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white400,
      appBar: AppBarWithBack(
        text: AppString.startTimer,
        backgroundColor: AppColors.white400,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: AppString.emotionRegulation,
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 24),
                    fontWeight: FontWeight.w500,
                    lineHeight: 0.73,
                    color: AppColors.grey500,
                  ),
                  Gap(height: 15),
                  AppText(
                    text: AppString.emotionRegulationDescription,
                    fontSize: AppSize.width(value: 16),
                    fontFamilyIndex: 2,
                    lineHeight: 1.32,
                    maxLines: 15,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.secondary400,
                  ),
                ],
              ),
            ),
            Gap(height: 20),
            AppText(
              text: AppString.task,
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 16),
              lineHeight: 1.32,
              fontWeight: FontWeight.w500,
            ),
            Gap(height: 8),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.height(value: 20),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  checkBoxWithText(controller, "editPdf", AppString.editThePdf),
                  checkBoxWithText(
                    controller,
                    "gratitudeJournal",
                    AppString.writeInagradititudeJournal,
                  ),
                  checkBoxWithText(
                    controller,
                    "followGoals",
                    AppString.followingThoughonGoals,
                  ),
                  checkBoxWithText(
                    controller,
                    "stretchDaily",
                    AppString.strechEverydayfor,
                  ),
                ],
              ),
            ),
            Gap(height: 20),
            Obx(
              () => AppButton(
                title: controller.isAllCompleted
                    ? "Mark As Completed"
                    : "Complete All Tasks (${(controller.completionPercentage * 100).toInt()}%)",
                backgroundColor: controller.isAllCompleted
                    ? AppColors.primary500
                    : AppColors.grey400,
                titleColor: controller.isAllCompleted
                    ? AppColors.white
                    : AppColors.black,
                onTap: () => controller.markAsCompleted(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkBoxWithText(
    MyTaskController controller,
    String key,
    String text,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: controller.getCheckboxState(key),
                onChanged: (value) => controller.toggleCheckbox(key, value),
                activeColor: AppColors.black,
                focusColor: AppColors.black,
              ),
              AppText(
                text: text,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
                lineHeight: 1.32,
                color: AppColors.secondary400,
              ),
            ],
          ),
          Divider(
            thickness: 1.5,
            color: AppColors.black.withValues(alpha: 0.15),
          ),
        ],
      ),
    );
  }
}
