import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/controller/bookings_sessions_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_loading/app_loading_widget.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsSessionsScreen extends StatelessWidget {
  const BookingsSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingsSessionsController());

    return Scaffold(
      appBar: AppBarWithBack(
        text: "Booked Sessions",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value && controller.bookings.isEmpty) {
          return const Center(child: AppLoadingWidget());
        }

        if (controller.bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                Gap(height: 16),
                AppText(
                  text: 'No bookings found',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshBookings,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 20),
              vertical: AppSize.height(value: 30),
            ),
            itemCount:
                controller.bookings.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.bookings.length) {
                controller.loadMoreBookings();
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: AppLoadingWidget()),
                );
              }

              final booking = controller.bookings[index];
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: AppSize.height(value: 15)),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.27),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 23.16,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: booking.userId?.profile != null
                              ? Image.network(
                                  '${booking.userId!.profile}',
                                  height: AppSize.height(value: 78),
                                  width: AppSize.width(value: 83),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppStaticImages.bookingImages,
                                      height: AppSize.height(value: 78),
                                      width: AppSize.width(value: 83),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  AppStaticImages.bookingImages,
                                  height: AppSize.height(value: 78),
                                  width: AppSize.width(value: 83),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Gap(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: booking.userId?.fullName ?? 'N/A',
                                fontSize: 20.85,
                                fontFamilyIndex: 2,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                              Gap(height: 04),
                              AppText(
                                text: 'Better Health Advocate',
                                fontSize: 15.06,
                                fontFamilyIndex: 2,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.35,
                                color: Color(0xFF309AAD),
                              ),
                              Gap(height: 03),
                              AppText(
                                text:
                                    'Duration: ${booking.scheduledDuration ?? 0} mins',
                                color: const Color(0xFF677294),
                                fontSize: 13.90,
                                fontFamilyIndex: 2,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.35,
                              ),
                              Gap(height: 02),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(booking.status),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: AppText(
                                  text: booking.status?.toUpperCase() ?? 'N/A',
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamilyIndex: 2,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 10),
                        vertical: AppSize.height(value: 10),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5F7),
                        borderRadius: BorderRadius.circular(9.27),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: 'Session Details',
                                  color: const Color(0xFF309AAD),
                                  fontSize: 16,
                                  fontFamilyIndex: 2,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.35,
                                ),
                                Gap(height: 03),
                                AppText(
                                  text: _formatBookingDateTime(
                                    booking.bookingDate,
                                    booking.startTime,
                                  ),
                                  fontFamilyIndex: 2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF677294),
                                ),
                                if (booking.endTime != null) ...[
                                  Gap(height: 02),
                                  AppText(
                                    text: 'End: ${booking.endTime}',
                                    fontFamilyIndex: 2,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF677294),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // AppButton(
                          //   title: "Set Reminder",
                          //   titleColor: AppColors.white,
                          //   padding: EdgeInsets.all(5),
                          //   fontSize: 10,
                          //   backgroundColor: AppColors.primary500,
                          //   height: AppSize.height(value: 30),
                          //   width: AppSize.width(value: 100),
                          //   onTap: () {
                          //     AppSnackBar.showWarning(
                          //       "This Feature will be implemented soon",
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _formatBookingDateTime(DateTime? date, String? time) {
    if (date == null) return 'Date not available';

    try {
      final months = [
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
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      final month = months[date.month - 1];
      final day = date.day;
      final weekday = weekdays[date.weekday - 1];

      final timeStr = time ?? 'Time TBD';
      return '$timeStr - $weekday, $month $day';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
