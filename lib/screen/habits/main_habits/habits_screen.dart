import 'package:better_help/screen/habits/main_habits/controller/habits_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_button/app_button_with_icon.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitsScreenController controller = Get.put(HabitsScreenController());

    return Scaffold(
      appBar: FlexibleCustomAppBar(
        appBarHeight: AppSize.height(value: 70),
        title: AppString.getReadytoStart,
        subtitle: AppString.mahbubulQareem,
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
        leadingImagePath: AppStaticImages.habitsAppbar,
        showCircleAvatar: true,
      ),
      backgroundColor: AppColors.habitBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: AppText(
                text: "Daily Affirmations",
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                fontWeight: FontWeight.w800,
                color: AppColors.grey500,
              ),
            ),
            Gap(height: 08),
            CarouselSlider(
              carouselController: controller.carouselController,
              items: controller.backgroundImages.asMap().entries.map((entry) {
                int index = entry.key;
                String imagePath = entry.value;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 22),
                        vertical: AppSize.height(value: 21),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppText(
                              text: controller.quoteList[index],
                              fontFamilyIndex: 4,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppText(
                              text: controller.quoteAuthorList[index],
                              fontFamilyIndex: 4,
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: AppSize.height(value: 137),
                aspectRatio: 16 / 9,
                viewportFraction: 0.85,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.linear,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  controller.updateCurrentIndex(index);
                },
              ),
            ),
            Gap(height: 16),
            Center(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(controller.backgroundImages.length, (
                    index,
                  ) {
                    return GestureDetector(
                      onTap: () => controller.goToSlide(index),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppSize.width(value: 3),
                        ),
                        height: AppSize.height(value: 8),
                        width: AppSize.width(value: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.5),
                          color: controller.currentIndex.value == index
                              ? AppColors.secondary900
                              : AppColors.iconLightgrey,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Gap(height: 16),
            Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: AppSize.width(value: 16),
              // ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  controller.updateSelectedDate(selectedDate);
                },
                headerProps: EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: DateFormatter.fullDateDayAsStrMY(),
                  monthStyle: TextStyle(
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary900,
                  ),
                  selectedDateStyle: TextStyle(
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary500,
                  ),
                ),
                dayProps: EasyDayProps(
                  height: AppSize.height(value: 90),
                  width: AppSize.width(value: 80),
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary500.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkGrey, width: 1),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary500,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey400,
                    ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary500, width: 2),
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: AppSize.width(value: 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary500,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
                timeLineProps: EasyTimeLineProps(
                  hPadding: AppSize.width(value: 16),
                  vPadding: AppSize.height(value: 16),
                  separatorPadding: AppSize.width(value: 12),
                ),
              ),
            ),
            Gap(height: 10),
            //! Schedule Containers for Selected Date (Horizontal)
            Obx(() {
              final schedules = controller.selectedDateSchedules;
              if (schedules.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 20),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSize.width(value: 20)),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                        color: const Color(0xFFF0F0F0),
                        width: 0.87,
                      ),
                      borderRadius: BorderRadius.circular(10.39),
                    ),
                    child: Center(
                      child: AppText(
                        text: "No schedules for this date",
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: AppSize.height(
                  value: 200,
                ), // Fixed height for horizontal scroll
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 20),
                  ),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: AppSize.width(
                        value: 300,
                      ), // Fixed width for each container
                      margin: EdgeInsets.only(
                        right: index < schedules.length - 1
                            ? AppSize.width(value: 12)
                            : 0,
                      ),
                      child: _buildScheduleContainer(schedules[index]),
                    );
                  },
                ),
              );
            }),

            //! Checklist
            Gap(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: AppText(
                text: "Check List",
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                fontWeight: FontWeight.w800,
                color: AppColors.grey500,
              ),
            ),
            Gap(height: 08),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: Column(
                children: List.generate(3, (index) {
                  List<String> checklistItems = [
                    AppString.drinkWaterDaily,
                    "Complete morning meditation",
                    "Practice gratitude journaling",
                  ];

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 16),
                      vertical: AppSize.height(value: 10),
                    ),
                    margin: EdgeInsets.only(bottom: AppSize.height(value: 10)),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.checklistStates[index],
                            onChanged: (value) {
                              controller.updateChecklistState(
                                index,
                                value ?? false,
                              );
                            },
                            checkColor: AppColors.white,
                            activeColor: AppColors.primary500,
                          ),
                        ),

                        Expanded(
                          child: AppText(
                            text: checklistItems[index],
                            fontSize: AppSize.width(value: 14),
                            fontWeight: FontWeight.w500,
                            fontFamilyIndex: 2,
                            color: AppColors.textPrimaryBlack,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Gap(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: IconAppButton(
                iconAlignment: CustomIconAlignment.left,
                title: AppString.startTimer,
                fontSize: AppSize.width(value: 16),
                backgroundColor: AppColors.blue500,
                titleColor: AppColors.white,
                icon: AppStaticImages.startTimer,
                onTap: () {},
              ),
            ),
            Gap(height: 100),
          ],
        ),
      ),
    );
  }

  // Helper method to build individual schedule container
  Widget _buildScheduleContainer(Map<String, dynamic> schedule) {
    Color backgroundColor = _getBackgroundColor(schedule['backgroundColor']);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 0.87, color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(10.39),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 13),
              vertical: AppSize.height(value: 10),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: schedule['title'],
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey500,
                      ),
                      AppText(
                        text: schedule['subtitle'],
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary900,
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.threedots,
                  height: AppSize.height(value: 24),
                  width: AppSize.width(value: 24),
                ),
              ],
            ),
          ),
          Gap(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(AppIcons.minuteMeditation),
                  Gap(width: 4),
                  AppText(
                    text: schedule['duration'],
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryBlack,
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(AppIcons.scheduleTime),
                  Gap(width: 4),
                  AppText(
                    text: schedule['time'],
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryBlack,
                  ),
                ],
              ),
            ],
          ),
          Gap(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppButton(
                width: AppSize.width(value: 130),
                title: AppString.startNow,
                backgroundColor: AppColors.blue500,
                fontSize: AppSize.width(value: 12),
                titleColor: AppColors.white,
                onTap: () {
                  // Handle start now action
                },
              ),
              AppButton(
                width: AppSize.width(value: 130),
                title: AppString.talkTobhaa,
                fontSize: AppSize.width(value: 12),
                backgroundColor: AppColors.white50,
                titleColor: AppColors.grey500,
                onTap: () {
                  // Handle talk to BHA action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to get background color based on string
  Color _getBackgroundColor(String colorName) {
    switch (colorName) {
      case 'primary50':
        return AppColors.primary50;
      case 'green50':
        return AppColors.green50;
      case 'blue50':
        return AppColors.blue50;
      case 'orange50':
        return AppColors.orange50;
      case 'red50':
        return AppColors.red50;
      case 'babygreen50':
        return AppColors.babygreen50;
      default:
        return AppColors.primary50;
    }
  }
}
