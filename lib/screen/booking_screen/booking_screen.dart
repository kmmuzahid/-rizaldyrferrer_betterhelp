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
              Stack(
                children: [
                  _buildCalendar(),
                  if (controller.isAvailableDateLoading.value)
                    const Positioned.fill(child: Center(child: CircularProgressIndicator())),
                ],
              ),
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
                              DateFormat('MMM dd yyyy').format(
                                controller.selectedDate.value?.toUtc() ?? DateTime.now().toUtc(),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.questionBg02TextColor,
                              ),
                            ),
                          ],
                        ),
                        controller.availableSlots.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 100),
                                  child: Text("No available slots"),
                                ),
                              )
                            : ConstrainedBox(
                                constraints: const BoxConstraints(minHeight: 200),
                                child: _buildTimeGrid(controller.availableSlots),
                              ),
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
        key: Key('table_calendar_booking_${controller.allData.length}'),
        focusedDay: controller.focuseDate.value,
        onPageChanged: (date) {
          controller.getAvailableDate(date);
        },
        selectedDayPredicate: (day) {
          if (controller.isAvailableSlotsLoading.value) return false;
          final selected = controller.selectedDate.value;
          if (selected == null) return false;
          return controller.isSameUtcDay(selected, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          controller.focuseDate.value = focusedDay;
          controller.onDaySelected(selectedDay);
        },
        enabledDayPredicate: (day) {
          return controller.availableDate.any((e) => controller.isSameUtcDay(e, day));
        },
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: false), 
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) =>
              _buildDayCell(context, day, isSelected: false),
          selectedBuilder: (context, day, focusedDay) =>
              _buildDayCell(context, day, isSelected: true),
          todayBuilder: (context, day, focusedDay) =>
              _buildDayCell(context, day, isSelected: false),
          disabledBuilder: (context, day, focusedDay) => _buildDisabledDayCell(context, day),
          outsideBuilder: (context, day, focusedDay) => _buildDisabledDayCell(context, day),
        ),
        calendarStyle: const CalendarStyle(outsideDaysVisible: false),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime day, {required bool isSelected}) {
    final isAvailable = controller.availableDate.any((e) => controller.isSameUtcDay(e, day));
    final isToday = controller.isSameUtcDay(day, DateTime.now());

    Color bgColor;
    Color textColor;

    if (isSelected) {
      bgColor = const Color(0xFF4A919E);
      textColor = Colors.white;
    } else if (isAvailable) {
      bgColor = Colors.teal.withOpacity(0.2);
      textColor = Colors.black;
    } else if (isToday) {
      bgColor = Colors.teal.withOpacity(0.2);
      textColor = Colors.black;
    } else {
      bgColor = Colors.transparent;
      textColor = Colors.grey.shade400;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: (isSelected || isAvailable) ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDisabledDayCell(BuildContext context, DateTime day) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
      child: Text(
        '${day.day}',
        style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400,
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
              '${selectedSlot.startTimeLocal} - ${DateFormat("h:mm a").format(selectedSlot.endTime.subtract(const Duration(minutes: 5)))}',
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
