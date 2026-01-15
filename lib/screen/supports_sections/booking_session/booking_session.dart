import 'package:better_help/screen/supports_sections/booking_session/controller/booking_session_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingSessionScreen extends StatelessWidget {
  const BookingSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingSessionController controller = Get.find<BookingSessionController>();

    return Scaffold(
      appBar: AppBarWithBack(
        text: "Report Problem",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height: 20),
            AppText(
              text:
                  "Please select a time with you better health advocate from these given timeslots",
              color: AppColors.black,
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w600,
              fontFamilyIndex: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              lineHeight: 1.5,
            ),
            Gap(height: 20),

            // Date containers section
            Obx(() {
              final bookingData = controller.bookingData;
              final List<Widget> dateRows = [];

              // Dynamically create rows based on bookingData length
              for (int i = 0; i < bookingData.length; i += 2) {
                dateRows.add(
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateContainer(bookingData[i], controller),
                      ),
                      if (i + 1 < bookingData.length) ...[
                        SizedBox(width: AppSize.width(value: 15)),
                        Expanded(
                          child: _buildDateContainer(
                            bookingData[i + 1],
                            controller,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
                dateRows.add(Gap(height: 15));
              }

              return Column(children: dateRows);
            }),

            Gap(height: 25),

            // Available slots section
            Obx(() {
              final availableSlots = controller.allAvailableSlots;

              if (availableSlots.isEmpty) {
                return Center(
                  child: AppText(
                    text: "No available slots for the selected dates",
                    fontFamilyIndex: 3,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Available Slots:",
                    fontFamilyIndex: 3,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  Gap(height: 15),

                  // Display slots in a grid
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableSlots.map((slot) {
                      final isSelected = controller.isSlotSelected(slot);
                      return GestureDetector(
                        onTap: () => controller.selectSlot(slot),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.width(value: 20),
                            vertical: AppSize.height(value: 12),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary500
                                : AppColors.primary50,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(color: AppColors.primary500)
                                : null,
                          ),
                          child: AppText(
                            text: slot,
                            fontFamilyIndex: 3,
                            fontSize: AppSize.width(value: 14),
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primary500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Show selected slot info
                  Obx(() {
                    final selectedDateInfo = controller.selectedDateInfo;
                    if (selectedDateInfo != null &&
                        controller.selectedSlot.value != null) {
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(AppSize.width(value: 15)),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Selected Appointment:",
                              fontFamilyIndex: 3,
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                            Gap(height: 8),
                            AppText(
                              text:
                                  "${selectedDateInfo.formattedDate} at ${controller.selectedSlot.value}",
                              fontFamilyIndex: 3,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary500,
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              );
            }),

            Gap(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDateContainer(
    BookingDate bookingDate,
    BookingSessionController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 15),
        vertical: AppSize.height(value: 15),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: bookingDate.formattedDate,
            fontFamilyIndex: 3,
            fontSize: AppSize.width(value: 14),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          Gap(height: 8),
          AppText(
            text: bookingDate.hasSlots
                ? "${bookingDate.slots.length} slot${bookingDate.slots.length > 1 ? 's' : ''} available"
                : "No available slots",
            fontFamilyIndex: 3,
            fontSize: AppSize.width(value: 11),
            fontWeight: FontWeight.w500,
            color: bookingDate.hasSlots
                ? AppColors.primary500
                : AppColors.black,
          ),
        ],
      ),
    );
  }
}
