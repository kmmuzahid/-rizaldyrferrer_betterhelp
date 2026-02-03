/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 14:55:55
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var selectedTime = "".obs;
  var isAvailableSlotsLoading = false.obs;

  final List<String> morningSlots = [
    "09:00 AM",
    "09:45 AM",
    "10:00 AM",
    "10:45 AM",
    "11:00 AM",
    "11:45 AM",
  ];

  final List<String> afternoonSlots = [
    "12:00 PM",
    "12:45 PM",
    "01:00 PM",
    "01:45 PM",
    "02:00 PM",
    "02:45 PM",
    "03:00 PM",
    "03:45 PM",
  ];

  final List<String> nightSlots = [
    "06:00 PM",
    "06:45 PM",
    "07:00 PM",
    "07:45 PM",
    "08:00 PM",
    "08:45 PM",
  ];

  RxList<String> availableSlots = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    onDaySelected(DateTime.now());
  }

  onDaySelected(DateTime date) async {
    if (selectedDate.value == date && isAvailableSlotsLoading.value) return;
    selectedDate.value = date;
    availableSlots.clear();
    isAvailableSlotsLoading.value = true;
    final response = await DioService.instance.request<List<String>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getDoctorAvailableSlots,
        queryParams: {'date': selectedDate.value.toUtc().toIso8601String()},
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return (data as List).map((e) => e['startTime'].toString()).toList();
      },
    );
    if (response.isSuccess) {
      if (response.data?.isNotEmpty ?? false) {
        availableSlots.assignAll(response.data ?? []);
      } else {
        showSnackBar('No available slots found', type: SnackBarType.warning);
      }
    } else {
      showSnackBar(response.message ?? '', type: SnackBarType.error);
      availableSlots.clear();
    }
    availableSlots.refresh();
    isAvailableSlotsLoading.value = false;
  }

  void selectTime(String time) {
    selectedTime.value = time;
  }

  String getNext45MinSlot(String inputTime) {
    final input = _parseTime(inputTime);

    final next = input.add(const Duration(minutes: 45));

    final endTime = _formatTime(next);

    return endTime.length == 7 ? "0$endTime" : endTime;
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final meridian = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute $meridian";
  }

  DateTime _parseTime(String time) {
    final parts = time.split(' ');
    final timePart = parts[0];
    final meridian = parts[1];

    final hourMinute = timePart.split(':');
    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    if (meridian == 'PM' && hour != 12) hour += 12;
    if (meridian == 'AM' && hour == 12) hour = 0;

    return DateTime(2026, 1, 1, hour, minute);
  }

  bool isTimeSelectable({required DateTime selectedDate, required String time}) {
    if (time.isEmpty || (time == nightSlots[nightSlots.length - 1])) return false;

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

  void confirmBooking() async {
    if (selectedTime.value.isEmpty) {
      showSnackBar('Please select a time slot', type: SnackBarType.warning);
      return;
    }
    DioService.instance.request<dynamic>(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.createDoctorBooking,
        method: RequestMethod.POST,
        jsonBody: {
          "bookingDate": selectedDate.value.toUtc().toIso8601String(),
          "startTime": selectedTime.value,
          "endTime": getNext45MinSlot(selectedTime.value),
        },
      ),
      responseBuilder: (data) {
        return data;
      },
    );
  }
}
