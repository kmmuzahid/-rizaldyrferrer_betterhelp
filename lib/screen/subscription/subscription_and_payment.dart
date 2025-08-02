import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SubscriptionAndPayment extends StatelessWidget {
  const SubscriptionAndPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SubscriptionAndPaymentController(),
      tag: 'subscription',
    );
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
          child: Column(
            children: [
              Gap(height: AppSize.height(value: 15)),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: AppText(
                    text: AppString.skip,
                    fontSize: AppSize.width(value: 20),
                    color: AppColors.blue500,
                    decoration: TextDecoration.underline,
                    lineHeight: 0.80,
                    fontWeight: FontWeight.w600,
                    fontFamilyIndex: 3,
                  ),
                ),
              ),
              controller.currentPageIndex.value == 4
                  ? Gap(height: AppSize.height(value: 10))
                  : Gap(height: AppSize.height(value: 15)),
              controller.currentPageIndex.value == 4
                  ?
                    // ? CustomRichText(
                    //     segments: [
                    //       TextSegment(
                    //         text: 'Please \nDon’t Leave Too Fast.\nLet’s Do ',
                    //         color: const Color(0xFF144149),
                    //         fontFamily: 'Playfair Display',
                    //         fontSize: 32,
                    //         fontWeight: FontWeight.w800,
                    //         height: 0.12,
                    //         letterSpacing: 0.5,
                    //       ),
                    //       TextSegment(
                    //         text: 'Free ',
                    //         color: const Color(0xFF4E61F6),
                    //         fontSize: 32,
                    //         fontFamily: 'Playfair Display',
                    //         fontWeight: FontWeight.w800,
                    //         height: 0.12,
                    //       ),
                    //       TextSegment(
                    //         text: '15',
                    //         color: const Color(0xFF4E61F6),
                    //         fontSize: 32,
                    //         fontFamily: 'Playfair Display',
                    //         fontWeight: FontWeight.w800,
                    //         height: 0.12,
                    //       ),
                    //       TextSegment(
                    //         text: 'min Talk ',
                    //         color: const Color(0xFF4E61F6),
                    //         fontSize: 32,
                    //         fontFamily: 'Playfair Display',
                    //         fontWeight: FontWeight.w800,
                    //         height: 0.12,
                    //       ),
                    //     ],
                    //   )
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: AppString.pleaseDontLeave,
                          fontSize: AppSize.width(value: 32),
                          fontFamilyIndex: 1,
                          fontWeight: FontWeight.w800,
                          maxLines: 4,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: AppString.enrollment,
                          fontSize: AppSize.width(value: 36),
                          lineHeight: 1.06,
                          color: AppColors.subscriptionTitleText,
                          fontWeight: FontWeight.w800,
                        ),
                        Gap(height: AppSize.height(value: 16)),
                        AppText(
                          text: AppString.unlockAllThePower,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.darkGrey,
                          fontSize: AppSize.width(value: 16),
                          lineHeight: 1.25,
                        ),
                      ],
                    ),
              controller.currentPageIndex.value == 4
                  ? Gap(height: AppSize.height(value: 10))
                  : Gap(height: AppSize.height(value: 24)),
              // PageView
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    SingleChildScrollView(child: momentum(controller)),
                    SingleChildScrollView(child: accelerate(controller)),
                    SingleChildScrollView(child: elevate(controller)),
                    SingleChildScrollView(child: ignite(controller)),
                    SingleChildScrollView(child: bookingMeeting()),
                  ],
                ),
              ),

              Gap(height: AppSize.height(value: 20)),
              Obx(
                () => controller.currentPageIndex.value == 4
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.totalPages - 1,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: controller.currentPageIndex.value == index
                                ? 20
                                : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: controller.currentPageIndex.value == index
                                  ? AppColors.t3
                                  : AppColors.grey500.withValues(alpha: 0.3),
                              borderRadius:
                                  controller.currentPageIndex.value == index
                                  ? BorderRadius.circular(6)
                                  : BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
              ),
              // // Navigation Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Obx(
              //       () => controller.currentPageIndex.value > 0
              //           ? GestureDetector(
              //               onTap: controller.previousPage,
              //               child: AppText(
              //                 text: 'Previous',
              //                 color: AppColors.blue500,
              //                 fontSize: AppSize.width(value: 16),
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             )
              //           : const SizedBox(width: 80),
              //     ),
              //     Obx(
              //       () =>
              //           controller.currentPageIndex.value <
              //               controller.totalPages - 1
              //           ? GestureDetector(
              //               onTap: controller.nextPage,
              //               child: AppText(
              //                 text: 'Next',
              //                 color: AppColors.blue500,
              //                 fontSize: AppSize.width(value: 16),
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             )
              //           : const SizedBox(width: 80),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget momentum(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.momentumBg,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription01,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.momentum,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 08)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.blue500,
          titleColor: AppColors.white,
        ),
      ],
    ),
  ),
);

Widget accelerate(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.accelerationBg,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription02,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.acceleration,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 10)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.accelerationButton,
          titleColor: AppColors.white,
        ),
      ],
    ),
  ),
);

Widget elevate(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.elevate,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription03,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.elevate,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 10)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.elevateButton,
          titleColor: AppColors.white,
        ),
      ],
    ),
  ),
);

Widget ignite(SubscriptionAndPaymentController controller) => Container(
  decoration: BoxDecoration(
    color: AppColors.igniteBg,
    borderRadius: BorderRadius.all(Radius.circular(AppSize.width(value: 12))),
    border: Border.all(
      width: AppSize.width(value: 2),
      color: const Color(0xFFEAECF0),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x0F222C5C),
        blurRadius: 74.18,
        offset: Offset(63.27, 28.36),
        spreadRadius: 0,
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width(value: 20),
      vertical: AppSize.height(value: 15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            AppStaticImages.subscription03,
            height: AppSize.height(value: 180),
            width: AppSize.width(value: 180),
          ),
        ),
        Gap(height: AppSize.height(value: 15)),
        AppText(
          text: AppString.ignite,
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 28),
          color: AppColors.subscriptionTitleText,
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 08)),
        AppText(
          text: AppString.first30daysFree,
          lineHeight: 1.0,
          color: const Color(0xFFFFC05B),
          fontFamilyIndex: 3,
          fontSize: AppSize.width(value: 16),
          fontWeight: FontWeight.w600,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: AppString.year99,
          fontSize: AppSize.width(value: 20),
          color: AppColors.subscriptionTitleText,
          fontFamilyIndex: 4,
          fontWeight: FontWeight.w700,
        ),
        Gap(height: AppSize.height(value: 10)),
        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 05)),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.subscriptioncheck,
                  height: AppSize.height(value: 14),
                  width: AppSize.width(value: 14),
                ),
                Gap(width: AppSize.width(value: 08)),
                AppText(
                  text: AppString.unlimitedLikes,
                  fontFamilyIndex: 3,
                  fontSize: AppSize.width(value: 14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  lineHeight: 1.99,
                  letterSpacing: -0.28,
                ),
              ],
            ),
          );
        }),
        Gap(height: AppSize.height(value: 12)),
        AppButton(
          title: AppString.getNow,
          onTap: controller.selectPlan,
          height: AppSize.height(value: 48),
          backgroundColor: AppColors.igniteButton,
          titleColor: AppColors.black,
        ),
      ],
    ),
  ),
);

Widget bookingMeeting() {
  return GetBuilder<SubscriptionAndPaymentController>(
    tag: 'subscription',
    builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(height: AppSize.height(value: 10)),
          SfDateRangePicker(
            backgroundColor: AppColors.white,
            selectionMode: DateRangePickerSelectionMode.single,
            selectionColor: AppColors.black,
            toggleDaySelection: true,
            view: DateRangePickerView.month,
            selectionShape: DateRangePickerSelectionShape.rectangle,
            headerStyle: const DateRangePickerHeaderStyle(
              backgroundColor: AppColors.white500,
              textStyle: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value is DateTime) {
                controller.selectDate(args.value);
              }
            },
          ),
          Gap(height: AppSize.height(value: 20)),
          // Horizontally scrollable date selection containers
          _buildDateScrollView(controller),
          Gap(height: AppSize.height(value: 20)),
          // Show available slots for selected date
          _buildAvailableSlots(controller),
          Gap(height: AppSize.height(value: 50)),
          AppButton(
            title: AppString.confirmBooking,
            titleColor: AppColors.white,
            backgroundColor: AppColors.primary500,
            onTap: () {
              Get.toNamed(AppRoute.signupScreen);
            },
          ),
        ],
      );
    },
  );
}

Widget _buildDateScrollView(SubscriptionAndPaymentController controller) {
  DateTime today = DateTime.now();
  List<DateTime> dates = [];
  // Generate dates for the past 7 days, today, and next 20 days
  for (int i = -7; i <= 20; i++) {
    dates.add(today.add(Duration(days: i)));
  }
  return SizedBox(
    height: AppSize.height(value: 73),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 16)),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        DateTime date = dates[index];
        bool isToday = controller.isSameDay(date, today);
        return Container(
          width: AppSize.width(value: 110),
          margin: EdgeInsets.only(right: AppSize.width(value: 12)),
          child: _buildDateContainer(
            controller,
            date,
            controller.getDateDisplayText(date),
            controller.getSlotsForDate(date),
            isToday: isToday,
          ),
        );
      },
    ),
  );
}

Widget _buildAvailableSlots(SubscriptionAndPaymentController controller) {
  List<String> slots = controller.getSlotsForDate(
    controller.selectedDate.value,
  );

  if (slots.isEmpty) {
    return Container();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(
        text: "Available Slots",
        fontSize: AppSize.width(value: 16),
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        fontFamilyIndex: 2,
      ),
      Gap(height: AppSize.height(value: 10)),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: slots
            .map(
              (slot) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 12),
                  vertical: AppSize.height(value: 8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary500),
                ),
                child: AppText(
                  text: slot,
                  fontSize: AppSize.width(value: 12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  fontFamilyIndex: 2,
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

Widget _buildDateContainer(
  SubscriptionAndPaymentController controller,
  DateTime date,
  String dateText,
  List<String> slots, {
  bool isToday = false,
}) {
  bool isSelected = controller.isDateSelected(date);
  bool hasSlots = slots.isNotEmpty;
  bool isPastDate = date.isBefore(DateTime.now().subtract(Duration(hours: 1)));

  return GestureDetector(
    onTap: () => controller.selectDate(date),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 8),
        vertical: AppSize.height(value: 10),
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary500
            : isPastDate
            ? AppColors.grey500.withValues(alpha: 0.1)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primary500
              : isToday
              ? AppColors.primary500
              : isPastDate
              ? AppColors.grey500.withValues(alpha: 0.3)
              : const Color(0x19677294),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            text: _getShortDateText(date),
            fontWeight: FontWeight.w600,
            letterSpacing: -0.20,
            fontFamilyIndex: 3,
            fontSize: AppSize.width(value: 12),
            color: isSelected
                ? AppColors.white
                : isPastDate
                ? AppColors.grey500
                : AppColors.black,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          Gap(height: AppSize.height(value: 4)),
          AppText(
            text: hasSlots
                ? "${slots.length} slot${slots.length > 1 ? 's' : ''}"
                : "No slots",
            fontWeight: FontWeight.w400,
            letterSpacing: -0.20,
            fontFamilyIndex: 3,
            fontSize: AppSize.width(value: 9),
            color: hasSlots
                ? (isSelected ? AppColors.white : AppColors.green400)
                : AppColors.grey500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

String _getShortDateText(DateTime date) {
  DateTime today = DateTime.now();
  DateTime tomorrow = today.add(Duration(days: 1));
  DateTime yesterday = today.subtract(Duration(days: 1));

  List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String dayName = weekdays[date.weekday - 1];
  String monthName = months[date.month - 1];

  if (date.day == today.day &&
      date.month == today.month &&
      date.year == today.year) {
    return '$dayName, ${date.day} $monthName';
  } else if (date.day == tomorrow.day &&
      date.month == tomorrow.month &&
      date.year == tomorrow.year) {
    return '$dayName, ${date.day} $monthName';
  } else if (date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {
    return '$dayName, ${date.day} $monthName';
  }

  return '$dayName\n${date.day} $monthName';
}
