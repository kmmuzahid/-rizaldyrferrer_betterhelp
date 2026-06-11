/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/booking_session_model.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/bookings_model.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get.dart';

class BookingsSessionsController extends GetxController {
  RxList<BookedSessionModel> bookingSessionModel = <BookedSessionModel>[].obs;
  var isLoading = false.obs;

  // Loading state
  //final RxBool isLoading = false.obs;

  // Bookings list
  final RxList<BookingsModel> bookings = <BookingsModel>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final Rx<BookingMeta?> meta = Rx<BookingMeta?>(null);

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
    final result = await CkTransport.request<List<BookedSessionModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getMyBooking,
        queryParams: {'page': page, 'limit': 10},
        method: RequestMethod.GET,
      ),
      responseBuilder: (response) {
        return List<BookedSessionModel>.from(
          response.map((x) => BookedSessionModel.fromJson(x)),
        );
      },
    );
    isLoading.value = false;

    if (result.isSuccess) {
      bookingSessionModel.addAll(result.data ?? []);
    }
  }

  joinSession(BookedSessionModel? bookingSessionModel) async {
    if (bookingSessionModel == null) return;

    DateTime currentDateTime = DateTime.now();

    if (currentDateTime.isAfter(bookingSessionModel.endTime)) {
      CkSnackBar('Session Over', type: .warning);
      return;
    }

    if (currentDateTime.isBefore(bookingSessionModel.startTime)) {
      CkSnackBar('Session Not Started', type: .warning);
      return;
    }

    Get.toNamed(
      AppRoute.videoCallScreen,
      arguments: {'id': bookingSessionModel.id},
    );
    fetchBookings();
  }

  bool isJoainable(BookedSessionModel? model) {
    if (model == null) return false;

    DateTime currentDateTime = DateTime.now().toLocal();

    return currentDateTime.isAfter(model.startTime.toLocal()) &&
        currentDateTime.isBefore(model.endTime.toLocal());
  }

  /// Fetch bookings from API
  Future<void> fetchBookings({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 1;
      bookings.clear();
      hasMore.value = true;
    }

    isLoading.value = true;
    appLog('Fetching bookings - Page: ${currentPage.value}');

    final response = await CkTransport.request<BookingsResponse>(
      input: RequestInput(
        endpoint:
            '${ApiEndPoints.seeAllBookings}?page=${currentPage.value}&limit=10',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => BookingsResponse.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('Bookings fetched successfully');

      if (response.data?.data != null) {
        if (refresh) {
          bookings.value = response.data!.data!;
        } else {
          bookings.addAll(response.data!.data!);
        }

        // Check if there are more bookings based on length of fetched items
        hasMore.value = response.data!.data!.length >= 10;

        meta.value = BookingMeta(
          page: currentPage.value,
          limit: 10,
          total: bookings.length,
          totalPage: hasMore.value ? currentPage.value + 1 : currentPage.value,
        );

        appLog('Loaded ${bookings.length} bookings');
      } else {
        appLog('No bookings found');
      }
    } else {
      appLog('Failed to fetch bookings');
    }

    isLoading.value = false;
  }

  /// Load more bookings (pagination)
  Future<void> loadMoreBookings() async {
    if (!hasMore.value || isLoading.value) return;

    currentPage.value++;
    await fetchBookings();
  }

  /// Refresh bookings
  Future<void> refreshBookings() async {
    await fetchBookings(refresh: true);
  }

  @override
  void onClose() {
    appLog('BookingsSessionsController: Disposing controller');
    super.onClose();
  }
}
