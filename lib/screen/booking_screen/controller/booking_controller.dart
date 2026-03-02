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
  var focuseDate = DateTime.now().subtract(Duration(days: 1)).obs;

  RxList<SlotsModel> availableSlots = <SlotsModel>[].obs;

  RxList<DateTime> availableDate = <DateTime>[].obs;
  late DateTime _todayDayStart;
  late DateTime _todayDayEnd;
  @override
  void onInit() {
    super.onInit();
    _todayDayStart = startOfDayLocal(DateTime.now());
    _todayDayEnd = endOfDayLocal(DateTime.now());
    getAvailableDate(DateTime.now());
  }

  // Start of day in local time
  DateTime startOfDayLocal(DateTime localDate) =>
      DateTime(localDate.year, localDate.month, localDate.day, 0, 0);

  // End of day in local time
  DateTime endOfDayLocal(DateTime localDate) =>
      DateTime(localDate.year, localDate.month, localDate.day, 23, 59);

  getAvailableDate(DateTime date) async {
    isAvailableDateLoading.value = true;
    focuseDate.value = date;
    final result = await DioService.instance.request<List<DateTime>>(
      input: RequestInput(
        endpoint: ApiEndPoints.availableBookingDate,
        method: RequestMethod.GET,
        queryParams: {'date': date.toUtc().toIso8601String()},
      ),
      responseBuilder: (data) {
        return List.from(data).map((e) => DateTime.parse(e).toLocal()).toList();
      },
    );
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    if (result.isSuccess && result.data != null) {
      for (var dateTime in result.data!) {
        if (!availableDate.contains(dateTime) && dateTime.isAfter(yesterday)) {
          availableDate.add(dateTime);
        }
      }

      if (availableDate.isNotEmpty && availableSlots.isEmpty) {
        onDaySelected(availableDate.first);
      }
    }
    isAvailableDateLoading.value = false;
  }

  onDaySelected(DateTime date) async {
    if (selectedDate.value == date && isAvailableSlotsLoading.value) return;
    selectedSlot.value = null;

    selectedDate.value = date;
    availableSlots.clear();
    isAvailableSlotsLoading.value = true;
    final response = await DioService.instance.request<List<SlotsModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getDoctorAvailableSlots,
        queryParams: {
          'startTime': _todayDayStart.toUtc().toIso8601String(),
          'endTime': _todayDayEnd.toUtc().toIso8601String(),
        },
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return (data as List).map((e) => SlotsModel.fromJson(e)).toList();
      },
    );
    if (response.isSuccess) {
      if (response.data?.isNotEmpty ?? false) {
        if (date.date == DateTime.now().date) {
          availableSlots.assignAll(
            response.data?.where((e) => e.startTime.toLocal().isAfter(DateTime.now().toLocal())) ??
                [],
          );
        } else {
          availableSlots.assignAll(response.data ?? []);
        }
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

  void selectTime(SlotsModel slot, int index) {
    selectedSlot.value = slot;
    selectedIndex.value = index;
  }

  void confirmBooking() async {
    if (isBookingLoading.value) return;
    isBookingLoading.value = true;
    final response = await DioService.instance.request<dynamic>(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.createDoctorBooking,
        method: RequestMethod.POST,
        jsonBody: {
          "dayStartTime": _todayDayStart.toUtc().toIso8601String(),
          "dayEndTime": _todayDayEnd.toUtc().toIso8601String(),
          "startTime": selectedSlot.value?.startTime.toUtc().toIso8601String(),
          "endTime": selectedSlot.value?.endTime.toUtc().toIso8601String(),
        },
      ),
      responseBuilder: (data) {
        return data;
      },
    );
    isBookingLoading.value = false;
    if (response.isSuccess) {
      selectedSlot.value == null;
      availableSlots[selectedIndex.value] = availableSlots[selectedIndex.value].copyWith(
        isAvailable: false,
      );
      availableSlots.refresh();
    }
  }
}
