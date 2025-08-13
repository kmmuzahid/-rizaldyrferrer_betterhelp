import 'package:better_help/screen/habits_sections/timer_screen/controller/timer_screen_contorller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

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
              height: AppSize.height(value: 200),
              width: AppSize.width(value: 200),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SimpleCircularProgressBar(
                    size: 200,
                    valueNotifier: controller.valueNotifier,
                    fullProgressColor: AppColors.ocean600,
                    mergeMode: true,
                    animationDuration: 0,
                    backColor: AppColors.timerBackColor,
                    progressColors: [AppColors.blue500, AppColors.ocean500],
                    progressStrokeWidth: 25,
                    backStrokeWidth: 25,
                  ),
                  Obx(
                    () => Text(
                      controller.formattedTime,
                      style: TextStyle(
                        fontSize: AppSize.width(value: 25),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(height: 30),
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
          ],
        ),
      ),
    );
  }
}
