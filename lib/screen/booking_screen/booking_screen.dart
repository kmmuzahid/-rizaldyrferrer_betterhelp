/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 14:55:08
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/booking_screen/controller/booking_controller.dart';
import 'package:better_help/screen/booking_screen/model/slots_model.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingScreen extends StatelessWidget {
  BookingScreen({super.key});

  final BookingController controller = Get.put(BookingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Booking Session",
        backgroundColor: AppColors.white,
        actions: [],
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please select a time with you better health advocate from these given timeslots",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              _buildCalendar(),
              const SizedBox(height: 10),
              controller.isAvailableSlotsLoading.value
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      key: Key(
                        'booking_${controller.availableSlots.length}${controller.selectedSlot.value?.startTimeLocal}',
                      ),
                      children: [
                        Row(
                          children: [
                            _buildSectionHeader(Icons.wb_sunny_outlined, "Available Slots"),
                            const Spacer(),
                            Text(
                              DateFormat(
                                'MMM dd yyyy',
                              ).format(controller.selectedDate.value?.toLocal() ?? DateTime.now()),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.questionBg02TextColor,
                              ),
                            ),
                          ],
                        ),
                        controller.availableSlots.isEmpty
                            ? const Center(child: Text("No available slots"))
                            : _buildTimeGrid(controller.availableSlots),
                      ],
                    ),
              const SizedBox(height: 20),
              _buildConfirmButton(controller),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TableCalendar(
        key: Key('table_calendar_booking_${controller.availableDate.length}'),
        focusedDay: controller.focuseDate.value,
        onPageChanged: (date) {
          controller.getAvailableDate(date);
        },
        selectedDayPredicate: (day) {
          if (controller.isAvailableSlotsLoading.value) return false;
          return controller.selectedDate.value?.toLocal().date == day.toLocal().date;
        },
        onDaySelected: (selectedDay, focusedDay) {
          controller.onDaySelected(selectedDay);
        },
        enabledDayPredicate: (day) {
          final index = controller.availableDate.indexWhere((e) => e.date == day.toLocal().date);
          return index != -1;
        },
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: false),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(color: Color(0xFF4A919E), shape: BoxShape.circle),
          defaultDecoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          todayTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          todayDecoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2D5A64)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff2D5A64),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid(List<SlotsModel> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4.2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final selectedSlot = slots[index];
        final isSelected = selectedSlot == controller.selectedSlot.value;

        return GestureDetector(
          onTap: selectedSlot.isAvailable
              ? () => controller.selectTime(selectedSlot, index)
              : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B8A99)
                  : !selectedSlot.isAvailable
                  ? Colors.grey.withOpacity(0.8)
                  : const Color(0xFFD6E2E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${selectedSlot.startTimeLocal} - ${selectedSlot.endTimeLocal}',
              style: TextStyle(
                color: (!selectedSlot.isAvailable || isSelected)
                    ? Colors.white
                    : const Color(0xFF4A919E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton(BookingController controller) {
    return CommonButton(
      titleText: controller.isBookingLoading.value ? 'Processing...' : "Confirm Booking",
      buttonWidth: double.infinity,
      buttonRadius: 8,
      buttonColor: Colors.cyan,
      titleColor: Colors.white,
      onTap: () {
        controller.confirmBooking();
      },
      isLoading: controller.isBookingLoading.value,
    );
  }
}
