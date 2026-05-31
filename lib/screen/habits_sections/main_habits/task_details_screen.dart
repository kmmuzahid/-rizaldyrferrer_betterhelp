import 'package:better_help/screen/habits_sections/main_habits/controller/habits_screen_controller.dart';
import 'package:better_help/screen/habits_sections/main_habits/model/daily_task_model.dart';
import 'package:better_help/screen/supports_sections/main_supports/widgets/delay_picker.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Rx<TaskModel> taskData;

  final HabitsScreenController controller;

  const TaskDetailsScreen({
    super.key,
    required this.taskData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CkAppBar(
        title: "Task Details",
        appbarConfig: CkAppBarConfig(titleAlignment: .centerStart),
      ),
      body: _buildScheduleContainer(taskData),
    );
  }

  Widget _buildScheduleContainer(Rx<TaskModel> taskObs) {
    return Obx(() {
      final taskData = taskObs.value;
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 13),
                  vertical: AppSize.height(value: 10),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffEAF5F7),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    AppText(
                      text: taskData.taskGoal,
                      fontFamilyIndex: 2,
                      maxLines: 500,
                      textAlign: TextAlign.left,
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryBlack,
                    ),
                    AppText(
                      text: "Task Description",
                      fontFamilyIndex: 2,
                      textAlign: TextAlign.left,
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary900,
                    ),
                    Gap(height: 4),
                    AppText(
                      text: taskData.description,
                      fontFamilyIndex: 2,
                      textAlign: TextAlign.left,
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey500,
                      maxLines: 500,
                    ),
                    Gap(height: 12),
                    AppText(
                      text: "Target Domain",
                      fontFamilyIndex: 2,
                      textAlign: TextAlign.left,
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary900,
                      maxLines: 1,
                    ),
                    Gap(height: 4),
                    AppText(
                      text: taskData.title,
                      fontFamilyIndex: 2,
                      textAlign: TextAlign.left,
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey500,
                      maxLines: 500,
                    ),
                    Gap(height: 12),
                  ],
                ),
              ),
              Gap(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: AppColors.textMain,
                  ),
                  Gap(width: 6),
                  AppText(
                    text: controller.formatTimeRange(
                      taskData.startDate,
                      taskData.endDate,
                    ),
                    fontFamilyIndex: 2,
                    textAlign: TextAlign.left,
                    fontSize: AppSize.width(value: 12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryBlack,
                  ),
                ],
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (taskData.status == 'do_now')
                    Flexible(
                      child: AppButton(
                        height: AppSize.height(value: 36),
                        width: AppSize.width(value: 125),
                        title: "Completed",
                        backgroundColor: AppColors.blue500,
                        fontSize: AppSize.width(value: 12),
                        titleColor: AppColors.white,
                        onTap: () {
                          if (taskData.id.isNotEmpty) {
                            controller.markTaskAsCompleted(taskData.id);
                          }
                        },
                      ),
                    ),
                  if (taskData.status == 'pending') ...[
                    Flexible(
                      child: AppButton(
                        height: AppSize.height(value: 36),
                        width: AppSize.width(value: 125),
                        title: "Start Now",
                        backgroundColor: AppColors.blue500,
                        fontSize: AppSize.width(value: 12),
                        titleColor: AppColors.white,
                        onTap: () {
                          if (taskData.id.isNotEmpty) {
                            controller.startNow(taskData.id);
                          }
                        },
                      ),
                    ),
                    Gap(width: 8),
                    Flexible(
                      child: AppButton(
                        height: AppSize.height(value: 35),
                        width: AppSize.width(value: 115),
                        title: "Postpone",
                        fontSize: AppSize.width(value: 12),
                        backgroundColor: AppColors.white50,
                        titleColor: const Color.fromARGB(255, 168, 129, 129),
                        onTap: () {
                          if (taskData.id.isNotEmpty) {
                            Get.dialog<int>(
                              DelayPicker(
                                onSelect: (delay) {
                                  controller.postpone(taskData.id, delay);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Gap(width: 8),
                    Flexible(
                      child: AppButton(
                        height: AppSize.height(value: 35),
                        width: AppSize.width(value: 115),
                        title: "Skip",
                        fontSize: AppSize.width(value: 12),
                        backgroundColor: AppColors.white50,
                        titleColor: const Color.fromARGB(255, 168, 129, 129),
                        onTap: () {
                          if (taskData.id.isNotEmpty) {
                            controller.skip(taskData.id);
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
