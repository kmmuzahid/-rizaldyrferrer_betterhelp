import 'package:better_help/screen/progress_sections/main_progress/controller/progress_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProgressScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const ProgressScreen({super.key, this.scaffoldKey});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final ProgressScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProgressScreenController(), permanent: false);
  }

  @override
  void dispose() {
    Get.delete<ProgressScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlexibleCustomAppBar(
        title: AppString.trackProgress,
        subtitle: AppString.getreportsBasedonYou,
        leadingImagePath: AppStaticImages.progressAppbar,
        appBarHeight: AppSize.height(value: 70),
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
        onMenuTap: () => widget.scaffoldKey?.currentState?.openDrawer(),
      ),
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            children: [
              Gap(height: 20),

              //! Details Container
              Container(
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.09,
                      color: const Color(0xFFEAECF0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0F222C5C),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "POINTS EARNED",
                          fontFamilyIndex: 2,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.width(value: 12),
                          lineHeight: 1.67,
                        ),
                        Gap(height: 5),
                        Container(
                          padding: EdgeInsets.all(04.3),
                          height: AppSize.height(value: 26),
                          width: AppSize.width(value: 74),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFF3DA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.73),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.progressPointsEarned,
                                height: AppSize.height(value: 17),
                                width: AppSize.width(value: 17),
                              ),
                              Gap(width: 5),
                              Obx(
                                () => AppText(
                                  text: controller.pointsEarned.value
                                      .toString(),
                                  color: Color(0xFFFEA800),
                                  fontSize: AppSize.width(value: 14),
                                  fontFamilyIndex: 2,
                                  fontWeight: FontWeight.w800,
                                  lineHeight: 1.14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(height: 12),

                        //! Completed
                        AppText(
                          text: "COMPLETED",
                          color: Color(0xFF292929),
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w600,
                          lineHeight: 1.67,
                        ),
                        Gap(height: 5),
                        Obx(
                          () => AppText(
                            text: controller.completed.value.toString(),
                            color: Color(0xFF040415),
                            fontSize: AppSize.width(value: 20),
                            fontFamilyIndex: 2,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.31,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Best Strike Day
                        AppText(
                          text: "BEST STREAK DAY",
                          color: Color(0xFF292929),
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w600,
                          lineHeight: 1.67,
                        ),
                        Gap(height: 5),
                        Obx(
                          () => AppText(
                            text: controller.bestStreakDay.value.toString(),
                            color: Color(0xFF040415),
                            fontSize: AppSize.width(value: 20),
                            fontFamilyIndex: 2,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.31,
                          ),
                        ),

                        Gap(height: 12),

                        //! ReMaining Section
                        AppText(
                          text: "REMEAINING",
                          color: Color(0xFF292929),
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w600,
                          lineHeight: 1.67,
                        ),
                        Gap(height: 5),
                        Obx(
                          () => AppText(
                            text: controller.remaining.value.toString(),
                            color: Color(0xFFE3524F),
                            fontSize: AppSize.width(value: 20),
                            fontFamilyIndex: 2,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.31,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //! Graph Section
              Gap(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Task Summary",
                        color: Color(0xFF040415),
                        fontSize: AppSize.width(value: 16),
                        fontFamilyIndex: 2,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(height: 1),
                      AppText(
                        text: "May 28 - Jun 3",
                        color: Color(0xFF686873),
                        fontFamilyIndex: 2,
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Spacer(),
                  //! Previous Button
                  Container(
                    width: AppSize.width(value: 45),
                    height: AppSize.width(value: 45),
                    padding: const EdgeInsets.all(13.50),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.12,
                          color: const Color(0xFFEAECF0),
                        ),
                        borderRadius: BorderRadius.circular(17.99),
                      ),
                    ),
                    child: Center(child: SvgPicture.asset(AppIcons.arrowLeft)),
                  ),
                  Gap(width: 10),
                  Container(
                    width: AppSize.width(value: 45),
                    height: AppSize.width(value: 45),
                    padding: const EdgeInsets.all(13.50),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.12,
                          color: const Color(0xFFEAECF0),
                        ),
                        borderRadius: BorderRadius.circular(17.99),
                      ),
                    ),
                    child: Center(child: SvgPicture.asset(AppIcons.arrowRight)),
                  ),
                ],
              ),
              Gap(height: 10),
              Container(
                padding: EdgeInsets.only(
                  top: AppSize.height(value: 12),
                  left: AppSize.width(value: 12),
                  right: AppSize.width(value: 12),
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.03,
                      color: const Color(0xFFEAECF0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0F222C5C),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Productivity Hours",
                          fontFamilyIndex: 2,
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF404446),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 8.26,
                            left: 12.51,
                            right: 12.38,
                            bottom: 8.26,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEAF4FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(49.53),
                            ),
                          ),
                          child: Row(
                            children: [
                              AppText(
                                text: "Weekly",
                                fontFamilyIndex: 2,
                                fontSize: AppSize.width(value: 13),
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0095FF),
                              ),
                              Gap(width: 10),
                              InkWell(
                                onTap: () {
                                  // Handle dropdown tap
                                  appLog("Dropdown tapped");
                                },
                                child: SvgPicture.asset(AppIcons.dropdown),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(height: 30),
                    Obx(
                      () => SizedBox(
                        height: 250,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return AppText(
                                      text: value.toInt().toString(),
                                      fontSize: AppSize.width(value: 12),
                                      color: Color(0xFF686873),
                                      fontFamilyIndex: 2,
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    const days = [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun',
                                    ];
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < days.length) {
                                      return AppText(
                                        text: days[value.toInt()],
                                        fontSize: AppSize.width(value: 12),
                                        color: Color(0xFF686873),
                                        fontFamilyIndex: 2,
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: controller.chartData,
                                isCurved: true,
                                color: Color(0xFF0095FF),
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: Color(0xFF0095FF),
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Color(
                                    0xFF0095FF,
                                  ).withValues(alpha: 0.1),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) =>
                                    Color(0xFF0095FF),
                                getTooltipItems:
                                    (List<LineBarSpot> touchedBarSpots) {
                                      return touchedBarSpots.map((barSpot) {
                                        return LineTooltipItem(
                                          '${barSpot.y.toInt()}h',
                                          TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppSize.width(value: 12),
                                          ),
                                        );
                                      }).toList();
                                    },
                              ),
                              handleBuiltInTouches: true,
                              getTouchedSpotIndicator:
                                  (
                                    LineChartBarData barData,
                                    List<int> spotIndexes,
                                  ) {
                                    return spotIndexes.map((spotIndex) {
                                      return TouchedSpotIndicatorData(
                                        FlLine(
                                          color: Color(
                                            0xFF0095FF,
                                          ).withValues(alpha: 0.5),
                                          strokeWidth: 2,
                                          dashArray: [5, 5],
                                        ),
                                        FlDotData(
                                          getDotPainter:
                                              (spot, percent, barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 6,
                                                  color: Color(0xFF0095FF),
                                                  strokeWidth: 3,
                                                  strokeColor: Colors.white,
                                                );
                                              },
                                        ),
                                      );
                                    }).toList();
                                  },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
