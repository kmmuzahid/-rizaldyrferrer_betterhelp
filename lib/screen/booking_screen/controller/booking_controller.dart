import 'package:get/get.dart';

class BookingController extends GetxController {
  // Observable variables
  var selectedDate = DateTime.now().obs;
  var selectedTime = "".obs;

  // Mock data for time slots
  final List<String> morningSlots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
  ];

  final List<String> afternoonSlots = [
    "12:00 PM",
    "12:30 PM",
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
    "4:30 PM",
    "5:00 PM",
    "5:30 PM",
  ];

  final List<String> nightSlots = [
    "6:00 PM",
    "6:30 PM",
    "7:00 PM",
    "7:30 PM",
    "8:00 PM",
    "8:30 PM",
    "9:00 PM",
  ];

  void selectTime(String time) {
    selectedTime.value = time;
  }

  bool isTimeSelectable({required DateTime selectedDate, required String time}) {
    if (time.isEmpty) return false;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selectedDay.isBefore(today)) return false;

    if (selectedDay.isAfter(today)) return true;

    final selectedDateTime = _combineDateAndTime(selectedDay, time);

    return selectedDateTime.isAfter(now);
  }

  DateTime _combineDateAndTime(DateTime date, String time) {
    final parts = time.split(' ');
    final timePart = parts[0];
    final period = parts[1].toUpperCase();

    final hourMinute = timePart.split(':');
    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  void confirmBooking() {}
}
