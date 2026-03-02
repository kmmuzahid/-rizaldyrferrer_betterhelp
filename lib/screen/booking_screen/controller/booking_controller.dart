/*
 * @Author: Km Muzahid
 * @Date: 2026-01-10 14:55:55
 * @Email: km.muzahid@gmail.com
 */
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

  late DateTime _todayDayStart;
  late DateTime _todayDayEnd;

  @override
  void onInit() {
    super.onInit();
    _todayDayStart = startOfDayLocal(DateTime.now());
    _todayDayEnd = endOfDayLocal(DateTime.now());
    getAvailableDate(DateTime.now());
  }

  DateTime startOfDayLocal(DateTime localDate) =>
      DateTime(localDate.year, localDate.month, localDate.day, 0, 0);

  DateTime endOfDayLocal(DateTime localDate) =>
      DateTime(localDate.year, localDate.month, localDate.day, 23, 59);

  DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month, 1);
  DateTime endOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0);

  DateTime normalizeToUtcDate(DateTime date) {
    final utc = date.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day);
  }

  bool isSameUtcDay(DateTime a, DateTime b) {
    final utcA = a.toUtc();
    final utcB = b.toUtc();
    return utcA.year == utcB.year && utcA.month == utcB.month && utcA.day == utcB.day;
  }

  void addDateIfNotExists(List<DateTime> list, DateTime newDate) {
    final exists = list.any((date) => isSameUtcDay(date, newDate));
    if (!exists) {
      list.add(normalizeToUtcDate(newDate));
    }
  }

  void addSlotsIfNotExists(List<SlotsModel> list, SlotsModel newSlot) {
    final exists = list.any((slot) => slot.startTime.toUtc() == newSlot.startTime.toUtc());
    if (!exists) {
      list.add(newSlot);
    }
  }

  getAvailableDate(DateTime date) async {
    focuseDate.value = date;
    isAvailableDateLoading.value = true;

    ResponseState<List<SlotsModel>?> response = await DioService.instance.request<List<SlotsModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getDoctorAvailableSlots,
        queryParams: {
          'startTime': startOfMonth(date).toUtc().toIso8601String(),
          'endTime': endOfMonth(date).toUtc().toIso8601String(),
        },
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return (data as List).map((e) => SlotsModel.fromJson(e)).toList();
      },
    );

    for (SlotsModel element in response.data ?? []) {
      addSlotsIfNotExists(allData, element);
      addDateIfNotExists(availableDate, element.startTime);
    }

    isAvailableDateLoading.value = false;

    if (availableDate.isNotEmpty) {
      onDaySelected(availableDate.first);
    }
  }

  onDaySelected(DateTime date) async {
    selectedDate.value = null;
    selectedDate.value = normalizeToUtcDate(date);
    selectedIndex.value = -1;
    selectedSlot.value = null;

    final newData = allData.where((slot) => isSameUtcDay(slot.startTime, date)).toList();

    availableSlots.assignAll(newData);
    availableSlots.refresh();
  }

  void selectTime(SlotsModel slot, int index) {
    selectedSlot.value = slot;
    selectedIndex.value = index;
  }

void confirmBooking() async {
    if (isBookingLoading.value) return;
    isBookingLoading.value = true;

    // ✅ Save reference BEFORE nulling it
    final bookedSlot = selectedSlot.value;

    final response = await DioService.instance.request<dynamic>(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.createDoctorBooking,
        method: RequestMethod.POST,
        jsonBody: {
          "dayStartTime": _todayDayStart.toUtc().toIso8601String(),
          "dayEndTime": _todayDayEnd.toUtc().toIso8601String(),
          "startTime": bookedSlot?.startTime.toUtc().toIso8601String(),
          "endTime": bookedSlot?.endTime.toUtc().toIso8601String(),
        },
      ),
      responseBuilder: (data) => data,
    );

    isBookingLoading.value = false;

    if (response.isSuccess) {
      // ✅ Update availableSlots UI
      if (selectedIndex.value >= 0 && selectedIndex.value < availableSlots.length) {
        availableSlots[selectedIndex.value] = availableSlots[selectedIndex.value].copyWith(
          isAvailable: false,
        );
        availableSlots.refresh();
      }

      // ✅ Now safe to use bookedSlot — selectedSlot not nulled yet
      if (bookedSlot != null) {
        final index = allData.indexWhere(
          (e) => e.startTime.toUtc().isAtSameMomentAs(bookedSlot.startTime.toUtc()),
        );
        if (index != -1) {
          allData[index] = allData[index].copyWith(
            isAvailable: false,
          ); // ✅ mark unavailable, don't remove
        }
      }

      // ✅ Clear selection last
      selectedSlot.value = null;
      selectedIndex.value = -1;
    }
  }
}
