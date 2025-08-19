import 'package:better_help/screen/habits_sections/timer_screen/controller/timer_screen_contorller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_confeti/habit_complete_screen.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimerScreenController(), tag: 'timer_screen');
    return Scaffold(
      backgroundColor: AppColors.white400,
      appBar: AppBarWithBack(
        text: AppString.startTimer,
        backgroundColor: AppColors.white400,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: [
            Gap(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Good Morning, Rizal!",
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 18),
                      fontWeight: FontWeight.w500,
                    ),
                    Gap(height: 05),
                    AppText(
                      text: "Let's get productive today",
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 22.62),
                      fontWeight: FontWeight.w600,
                      lineHeight: 1.40,
                      letterSpacing: -0.45,
                    ),
                  ],
                ),
                SvgPicture.asset(
                  AppIcons.timerAppSchedule,
                  height: AppSize.height(value: 45),
                  width: AppSize.width(value: 45),
                ),
              ],
            ),
            Gap(height: 60),
            SizedBox(
              height: AppSize.height(value: 230),
              width: AppSize.width(value: 230),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: controller.valueNotifier,
                    builder: (context, progress, child) {
                      return CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 25.0,
                        animation: false, // Disable built-in animation
                        percent: progress / 100,
                        center: Obx(
                          () => Text(
                            controller.formattedTime,
                            style: TextStyle(
                              fontSize: AppSize.width(value: 25),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryBlack,
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: AppColors.blue500,
                        backgroundColor: AppColors.timerBackColor,
                      );
                    },
                  ),
                ],
              ),
            ),
            Gap(height: 40),
            Obx(
              () => AppButton(
                title: controller.isRunning.value ? "Pause" : "Start",
                backgroundColor: AppColors.blue500,
                titleColor: AppColors.white,
                onTap: () {
                  if (controller.isRunning.value) {
                    controller.pauseTimer();
                  } else {
                    controller.startTimer();
                  }
                },
                borderradius: 12,
              ),
            ),
            Gap(height: 20),
            AppButton(
              title: "Reset",
              backgroundColor: AppColors.white,
              titleColor: AppColors.black,
              borderColor: AppColors.black,
              onTap: () {
                controller.resetTimer();
              },
              borderradius: 12,
            ),
            Gap(height: 20),
            AppButton(
              title: "Set Custom Time",
              backgroundColor: AppColors.white,
              titleColor: AppColors.blue500,
              borderColor: AppColors.blue500,
              onTap: () {
                _showTimePickerDialog(context, controller);
              },
              borderradius: 12,
            ),
            Gap(height: 30),
            AppButton(
              title: "Set Custom Time",
              backgroundColor: AppColors.white,
              titleColor: AppColors.blue500,
              borderColor: AppColors.blue500,
              onTap: () {
                Get.to(HabitCompleteScreen());
              },
              borderradius: 12,
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    TimerScreenController controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedMinutes = 25; // Default to 25 minutes
        int selectedSeconds = 0; // Default to 0 seconds

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: AppText(
                text: "Set Custom Time",
                fontSize: AppSize.width(value: 18),
                fontWeight: FontWeight.w600,
                fontFamilyIndex: 2,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Minutes Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Minutes:",
                        fontSize: AppSize.width(value: 16),
                        fontWeight: FontWeight.w500,
                        fontFamilyIndex: 2,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (selectedMinutes > 1) selectedMinutes--;
                              });
                            },
                            icon: Icon(Icons.remove, color: AppColors.blue500),
                          ),
                          Container(
                            width: 50,
                            child: AppText(
                              text: selectedMinutes.toString(),
                              fontSize: AppSize.width(value: 18),
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                              fontFamilyIndex: 2,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (selectedMinutes < 60) selectedMinutes++;
                              });
                            },
                            icon: Icon(Icons.add, color: AppColors.blue500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(height: 10),
                  // Seconds Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Seconds:",
                        fontSize: AppSize.width(value: 16),
                        fontWeight: FontWeight.w500,
                        fontFamilyIndex: 2,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (selectedSeconds > 0) selectedSeconds--;
                              });
                            },
                            icon: Icon(Icons.remove, color: AppColors.blue500),
                          ),
                          Container(
                            width: 50,
                            child: AppText(
                              text: selectedSeconds.toString(),
                              fontSize: AppSize.width(value: 18),
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                              fontFamilyIndex: 2,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (selectedSeconds < 59) selectedSeconds++;
                              });
                            },
                            icon: Icon(Icons.add, color: AppColors.blue500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: AppText(
                    text: "Cancel",
                    color: AppColors.grey500,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    fontFamilyIndex: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Set the custom time in the controller
                    int totalSeconds = (selectedMinutes * 60) + selectedSeconds;
                    controller.setCustomTime(totalSeconds);
                    Navigator.of(context).pop();
                  },
                  child: AppText(
                    text: "Set Time",
                    color: AppColors.blue500,
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w600,
                    fontFamilyIndex: 2,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
