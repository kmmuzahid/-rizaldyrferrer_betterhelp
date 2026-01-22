/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/booking_session_model.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingsSessionsController extends GetxController {
  RxList<BookedSessionModel> bookingSessionModel = RxList();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingSession();
  }

  fetchBookingSession({bool refresh = false, int page = 1}) async {
    isLoading.value = true;
    if (refresh) {
      bookingSessionModel.clear();
    }
    final result = await DioService.instance.request<List<BookedSessionModel>>(
      input: RequestInput(
        endpoint: AppApiurl.getMyBooking,
        queryParams: {'page': page, 'limit': 10},
        method: RequestMethod.GET,
      ),
      responseBuilder: (response) {
        return List<BookedSessionModel>.from(response.map((x) => BookedSessionModel.fromJson(x)));
      },
    );
    isLoading.value = false;

    if (result.isSuccess) {
      bookingSessionModel.addAll(result.data ?? []);
    }
  }

  joinSession(BookedSessionModel? bookingSessionModel) async {
    if (bookingSessionModel == null) return;
    DateTime bookingDateTime = bookingSessionModel.bookingDate;

    DateFormat timeFormat = DateFormat("h:mm a");
    DateTime startTimeDate = timeFormat.parse(bookingSessionModel.startTime);

    DateTime finalStartDateTime = DateTime(
      bookingDateTime.year,
      bookingDateTime.month,
      bookingDateTime.day,
      startTimeDate.hour,
      startTimeDate.minute,
    );

    DateTime finalEndDateTime = DateTime(
      bookingDateTime.year,
      bookingDateTime.month,
      bookingDateTime.day,
      startTimeDate.hour,
      startTimeDate.minute + 45,
    );

    DateTime currentDateTime = DateTime.now();

    if (currentDateTime.isAfter(finalEndDateTime)) {
      showSnackBar('Session Over', type: SnackBarType.warning);
      return;
    }

    if (currentDateTime.isBefore(finalStartDateTime)) {
      showSnackBar('Session Not Started', type: SnackBarType.warning);
      return;
    }

    Get.toNamed(AppRoute.videoCallScreen, arguments: {'id': bookingSessionModel.id});
  }
}
