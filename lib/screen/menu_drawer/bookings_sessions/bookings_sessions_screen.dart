import 'package:better_help/screen/menu_drawer/bookings_sessions/controller/bookings_sessions_controller.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/booking_session_model.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsSessionsScreen extends StatelessWidget {
  const BookingsSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingsSessionsController>();
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Booked Sessions",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value && controller.bookingSessionModel.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return SmartListLoader(
          itemCount: controller.bookingSessionModel.length,
          onRefresh: () {
            controller.fetchBookingSession(refresh: true);
          },
          onLoadMore: (page) {
            controller.fetchBookingSession(refresh: false, page: page);
          },
          itemBuilder: (context, index) => _itemBuilder(
            controller.bookingSessionModel[index],
            controller,
            index,
          ),
        );
      }),
    );
  }

  Widget _itemBuilder(
    BookedSessionModel? bookingSessionModel,
    BookingsSessionsController controller,
    int index,
  ) {
    return Column(
      children: [
        if ((index > 0 &&
                controller.bookingSessionModel.length > index &&
                controller.bookingSessionModel[index - 1].status ==
                    "confirmed" &&
                controller.bookingSessionModel[index].status != "confirmed") ||
            (index == 0 &&
                controller.bookingSessionModel[index].status !=
                    "confirmed")) ...[
          SizedBox(
            child: Row(
              children: [
                Expanded(child: Container(height: 1.2, color: Colors.grey)),
                CommonText(
                  text: 'Completed Sessions',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                Expanded(child: Container(height: 1.2, color: Colors.grey)),
              ],
            ),
          ),
          10.height,
        ],
        Container(
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
                  Image.asset(
                    AppStaticImages.bookingImages,
                    height: AppSize.height(value: 78),
                    width: AppSize.width(value: 83),
                  ),
                  Gap(width: 13),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: bookingSessionModel?.doctorId.fullName ?? '',
                        fontSize: 20.85,
                        fontFamilyIndex: 2,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.35,
                      ),
                      Gap(height: 04),
                      AppText(
                        text: 'Bettter Health Advocate',
                        fontSize: 15.06,
                        fontFamilyIndex: 2,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.35,
                        color: Color(0xFF309AAD),
                      ),
                      Gap(height: 02),
                      AppText(
                        text: bookingSessionModel?.doctorId.email ?? '',
                        color: const Color(
                          0xFF131927,
                        ) /* Text-Color-text-primary-black */,
                        fontSize: 12,
                        fontFamilyIndex: 2,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.35,
                      ),
                    ],
                  ),
                ],
              ),
              Gap(height: 10),

              _runningSession(bookingSessionModel, controller),
            ],
          ),
        ),
      ],
    );
  }

  Container _runningSession(
    BookedSessionModel? bookingSessionModel,
    BookingsSessionsController controller,
  ) {
    final isConfirmed = bookingSessionModel?.status == "confirmed";
    final isJoinable = controller.isJoainable(bookingSessionModel);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 05)),
      height: AppSize.height(value: 65),
      decoration: BoxDecoration(
        color: isConfirmed
            ? const Color(0xFFEAF5F7)
            : const Color.fromARGB(255, 237, 237, 237),
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
                  text: isConfirmed ? 'Running Session' : 'Completed session',
                  color: isConfirmed
                      ? const Color(0xFF309AAD)
                      : const Color.fromARGB(255, 52, 51, 51),
                  fontSize: 16,
                  fontFamilyIndex: 2,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.35,
                ),
                Gap(height: 03),
                CommonText(
                  text:
                      "${CoreUtils.formatDateToShortMonth(bookingSessionModel?.bookingDate ?? DateTime.now())} (${bookingSessionModel?.startTime} - ${bookingSessionModel?.endTime})",
                  // fontFamilyIndex: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: Color(0xFF677294),
                ),
              ],
            ),
          ),
          if (isConfirmed)
            AppButton(
              title: isJoinable ? "Join Now" : "Upcoming",
              titleColor: AppColors.white,
              padding: EdgeInsets.all(5),
              fontSize: 10,
              backgroundColor: isJoinable ? AppColors.primary500 : Colors.grey,
              height: AppSize.height(value: 30),
              width: AppSize.width(value: 100),
              onTap: () {
                controller.joinSession(bookingSessionModel);
              },
            ),
        ],
      ),
    );
  }
}
