/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 14:55:08
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/booking_screen/controller/booking_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingScreen extends StatelessWidget {
  BookingScreen({super.key});

  final BookingController controller = Get.put(BookingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(text: "Booking Session", backgroundColor: AppColors.white),
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
              Column(
                key: Key(
                  'booking_${controller.availableSlots.length}${controller.selectedTime.toString()}',
                ),
                children: [
                  _buildSectionHeader(Icons.wb_sunny_outlined, "Morning"),
                  _buildTimeGrid(controller.morningSlots, controller.availableSlots),
                  const SizedBox(height: 10),
                  _buildSectionHeader(Icons.wb_twilight, "Afternoon"),
                  _buildTimeGrid(controller.afternoonSlots, controller.availableSlots),
                  const SizedBox(height: 10),
                  _buildSectionHeader(Icons.wb_twilight, "Night"),
                  _buildTimeGrid(controller.nightSlots, controller.availableSlots),
                ],
              ),
            const SizedBox(height: 20),
            _buildConfirmButton(),
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
          focusedDay: controller.selectedDate.value,
          selectedDayPredicate: (day) {
            return controller.selectedDate.value == day;
          },
          onDaySelected: (selectedDay, focusedDay) {
            controller.onDaySelected(selectedDay);
          },
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: false),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Color(0xFF4A919E),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.3),
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

  Widget _buildTimeGrid(List<String> slots, List<String> availableSlots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        String time = slots[index];
          bool isSelected = controller.selectedTime.value == time;
          bool isSelectable = controller.isTimeSelectable(
            selectedDate: controller.selectedDate.value,
            time: time,
          );

        isSelectable = isSelectable && availableSlots.contains(time);

          return GestureDetector(
            onTap: isSelectable ? () => controller.selectTime(time) : null,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected && isSelectable
                    ? const Color(0xFF3B8A99)
                    : !isSelectable
                    ? Colors.grey.withOpacity(0.8)
                    : const Color(0xFFD6E2E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected || !isSelectable ? Colors.white : const Color(0xFF4A919E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: controller.confirmBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B8A99),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("Confirm Booking", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
