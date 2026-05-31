import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/habits_sections/main_habits/controller/habits_screen_controller.dart';
import 'package:better_help/screen/habits_sections/main_habits/model/daily_task_model.dart';
import 'package:better_help/screen/habits_sections/main_habits/task_details_screen.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/supports_sections/main_supports/widgets/delay_picker.dart';
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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core_kit/image/ck_image.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HabitsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HabitsScreen({super.key, this.scaffoldKey});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final HabitsScreenController controller = Get.find<HabitsScreenController>();
  late final MyProfileScreenController profileController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<MyProfileScreenController>()) {
      profileController = Get.find<MyProfileScreenController>();
    } else {
      profileController = Get.put(MyProfileScreenController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.height(value: 70)),
        child: Obx(() {
          final profile = profileController.profileData.value;

          final String subtitle =
              profile?.fullName != null && profile!.fullName!.isNotEmpty
              ? profile.fullName!
              : AppString.mahbubulQareem;

          final String profileImageUrl = profileController.getProfileImageUrl();
          final String? profileImage = profileImageUrl.isNotEmpty
              ? profileImageUrl
              : null;

          return FlexibleCustomAppBar(
            appBarHeight: AppSize.height(value: 70),
            title: AppString.getReadytoStart,
            subtitle: subtitle,
            notificationIconPath: AppIcons.notificationIcons,
            menuIconPath: AppIcons.menuIcons,
            customLeading: _buildProfileLeading(profileImage),
            showCircleAvatar: false,
            onMenuTap: () => widget.scaffoldKey?.currentState?.openDrawer(),
          );
        }),
      ),
      backgroundColor: AppColors.habitBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            //   child: AppText(
            //     text: "Daily Affirmations",
            //     fontFamilyIndex: 2,
            //     fontSize: AppSize.width(value: 14),
            //     fontWeight: FontWeight.w800,
            //     color: AppColors.grey500,
            //   ),
            // ),
            Obx(
              () => CarouselSlider(
                carouselController: controller.carouselController,
                items: controller.dailyAffermationList.map<Widget>((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: RotatedBox(
                      quarterTurns:
                          -1, // 90 degrees clockwise (use 3 for counter-clockwise)
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: AppSize.height(value: 200),
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
            ),
            Gap(height: 16),
            Center(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    controller.dailyAffermationList.length,
                    (index) {
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
                    },
                  ),
                ),
              ),
            ),
            Gap(height: 16),
            Container(
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
                  dateFormatter: DateFormatter.custom('dd MMMM yyyy'),
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
              // Show loading indicator while fetching tasks
              if (controller.isLoadingTasks.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 20),
                  ),
                  child: Container(
                    height: AppSize.height(value: 220),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                        color: const Color(0xFFF0F0F0),
                        width: 0.87,
                      ),
                      borderRadius: BorderRadius.circular(10.39),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                );
              }

              if (controller.tasks.isEmpty) {
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

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: controller.tasks.asMap().entries.map((entry) {
                      int index = entry.key;
                      var task = entry.value;
                      return Container(
                        width: 300,
                        margin: EdgeInsets.only(
                          right: index < controller.tasks.length - 1
                              ? AppSize.width(value: 12)
                              : 0,
                        ),
                        child: _buildScheduleContainer(index, task),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
            //! Checklist
            Gap(height: 12),

            Gap(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: IconAppButton(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(value: 12),
                ),
                height: AppSize.height(value: 50),
                iconAlignment: CustomIconAlignment.left,
                title: AppString.startTimer,
                fontSize: AppSize.width(value: 16),
                backgroundColor: AppColors.blue500,
                titleColor: AppColors.white,
                icon: AppStaticImages.startTimer,
                onTap: () {
                  Get.toNamed(AppRoute.timerScreen);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: AppSize.height(value: 120),
        decoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  // Helper method to build individual schedule container
  Widget _buildScheduleContainer(int index, Rx<TaskModel> taskObs) {
    final TaskModel taskData = taskObs.value;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(width: 0.87, color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(10.39),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              //show details
              Get.to(
                () => TaskDetailsScreen(
                  taskData: taskObs,
                  controller: controller,
                ),
              );
            },
            child: Container(
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
                    maxLines: 2,
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
                    maxLines: 2,
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
                    maxLines: 2,
                  ),
                  Gap(height: 12),
                ],
              ),
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
          const Spacer(),
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

  Widget _buildProfileLeading(String? profileImage) {
    return Padding(
      padding: EdgeInsets.only(left: AppSize.width(value: 20)),
      child: CkImage(
        borderRadius: 12,
        src: profileImage ?? '',
        height: AppSize.height(value: 48),
        width: AppSize.width(value: 48),
        fill: BoxFit.cover,
      ),
    );
  }
}
