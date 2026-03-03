import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/booking_screen/model/slots_model.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  Rxn<SlotsModel> selectedSlot = Rxn<SlotsModel>();
  var isAvailableSlotsLoading = false.obs;
  var isBookingLoading = false.obs;
  var isAvailableDateLoading = false.obs;
  var selectedIndex = (-1).obs;
  var focuseDate = DateTime.now().obs;
  RxList<SlotsModel> availableSlots = <SlotsModel>[].obs;
  RxList<DateTime> availableDate = <DateTime>[].obs;
  final List<SlotsModel> allData = [];

  @override
  void onInit() {
    super.onInit();
    final nowLocal = DateTime.now();
    final localToday = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);

    focuseDate.value = localToday;
    getAvailableDate(localToday);
  }

  DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);
  DateTime endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 1);

  DateTime normalizeToLocalDate(DateTime date) {
    final local = date.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  bool isSameLocalDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void addDateIfNotExists(List<DateTime> list, DateTime utcDateTime) {
    final localDay = normalizeToLocalDate(utcDateTime);
    if (!list.any((date) => isSameLocalDay(date, localDay))) {
      list.add(localDay);
    }
  }

  void addSlotsIfNotExists(List<SlotsModel> list, SlotsModel newSlot) {
    if (!list.any((slot) => slot.startTime.toUtc().isAtSameMomentAs(newSlot.startTime.toUtc()))) {
      list.add(newSlot);
    }
  }
  

  Future<void> getAvailableDate(DateTime date) async {
    final localMonthStart = startOfMonth(date);
    final localMonthEnd = endOfMonth(date);

    focuseDate.value = normalizeToLocalDate(date);
    isAvailableDateLoading.value = true;

    ResponseState<List<SlotsModel>?> response = await DioService.instance.request<List<SlotsModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getDoctorAvailableSlots,
        queryParams: {
          'startTime': DateTime.now().toUtc().toIso8601String(),
          'endTime': localMonthEnd.toUtc().toIso8601String(),
        },
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => (data as List).map((e) => SlotsModel.fromJson(e)).toList(),
    );

    allData.clear();
    availableDate.clear();

    for (final element in response.data ?? []) {
      addSlotsIfNotExists(allData, element);
      addDateIfNotExists(availableDate, element.startTime);
    }

    // Sort dates and data to ensure consistency
    availableDate.sort();
    allData.sort((a, b) => a.startTime.compareTo(b.startTime));

    isAvailableDateLoading.value = false;

    if (availableDate.isNotEmpty) {
      // Prioritize today if available
      final today = normalizeToLocalDate(DateTime.now());
      final todayIndex = availableDate.indexWhere((d) => isSameLocalDay(d, today));

      if (todayIndex != -1) {
        onDaySelected(availableDate[todayIndex]);
      } else {
        onDaySelected(availableDate.first);
      }
    } else {
      selectedDate.value = null;
      availableSlots.clear();
    }
  }

  void onDaySelected(DateTime date) {
    // Treat the date fields from TableCalendar as the intended Local day
    final localDay = DateTime(date.year, date.month, date.day);

    selectedDate.value = localDay;
    selectedIndex.value = -1;
    selectedSlot.value = null;

    final newData = allData.where((slot) {
      final slotLocalDay = normalizeToLocalDate(slot.startTime);
      return isSameLocalDay(slotLocalDay, localDay);
    }).toList();

    availableSlots.assignAll(newData);
  }

  void selectTime(SlotsModel slot, int index) {
    selectedSlot.value = slot;
    selectedIndex.value = index;
  }

  Future<void> confirmBooking() async {
    if (isBookingLoading.value) return;

    final bookedSlot = selectedSlot.value;
    if (bookedSlot == null) return;

    final localDay = normalizeToLocalDate(bookedSlot.startTime.toLocal());
    final dayStartUtc = DateTime.utc(localDay.year, localDay.month, localDay.day, 0, 0);
    final dayEndUtc = DateTime.utc(localDay.year, localDay.month, localDay.day, 23, 59, 59);

    isBookingLoading.value = true;

    final response = await DioService.instance.request<dynamic>(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.createDoctorBooking,
        method: RequestMethod.POST,
        jsonBody: {
          "dayStartTime": dayStartUtc.toIso8601String(),
          "dayEndTime": dayEndUtc.toIso8601String(),
          "startTime": bookedSlot.startTime.toUtc().toIso8601String(),
          "endTime": bookedSlot.endTime.toUtc().toIso8601String(),
        },
      ),
      responseBuilder: (data) => data,
    );

    isBookingLoading.value = false;

    if (response.isSuccess) {
      if (selectedIndex.value >= 0 && selectedIndex.value < availableSlots.length) {
        availableSlots[selectedIndex.value] = availableSlots[selectedIndex.value].copyWith(
          isAvailable: false,
        );
        availableSlots.refresh();
      }

      final index = allData.indexWhere(
        (e) => e.startTime.toUtc().isAtSameMomentAs(bookedSlot.startTime.toUtc()),
      );
      if (index != -1) {
        allData[index] = allData[index].copyWith(isAvailable: false);
      }

      selectedSlot.value = null;
      selectedIndex.value = -1;
    }
  }
}
