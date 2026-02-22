/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/booking_session_model.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/model/bookings_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class BookingsSessionsController extends GetxController {
  RxList<BookedSessionModel> bookingSessionModel = RxList();
  var isLoading = false.obs;
  final _apiServices = ApiServices.instance;

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
    final result = await DioService.instance.request<List<BookedSessionModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.getMyBooking,
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
 

    DateTime currentDateTime = DateTime.now();

    if (currentDateTime.isAfter(bookingSessionModel.endTime)) {
      showSnackBar('Session Over', type: SnackBarType.warning);
      return;
    }

    if (currentDateTime.isBefore(bookingSessionModel.startTime)) {
      showSnackBar('Session Not Started', type: SnackBarType.warning);
      return;
    }

    Get.toNamed(AppRoute.videoCallScreen, arguments: {'id': bookingSessionModel.id});
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

    try {
      if (refresh) {
        currentPage.value = 1;
        bookings.clear();
        hasMore.value = true;
      }

      isLoading.value = true;
      appLog('Fetching bookings - Page: ${currentPage.value}');

      final response = await _apiServices.apiGetServices(
        '${ApiEndPoints.seeAllBookings}?page=${currentPage.value}&limit=10',
      );

      if (response != null && response['success'] == true) {
        appLog('Bookings fetched successfully');

        final bookingsResponse = BookingsResponse.fromJson(response);

        if (bookingsResponse.data != null) {
          if (refresh) {
            bookings.value = bookingsResponse.data!;
          } else {
            bookings.addAll(bookingsResponse.data!);
          }

          meta.value = bookingsResponse.meta;

          // Check if there are more bookings
          if (bookingsResponse.meta != null) {
            hasMore.value =
                currentPage.value < (bookingsResponse.meta!.totalPage ?? 0);
          }

          appLog('Loaded ${bookings.length} bookings');
        } else {
          appLog('No bookings found');
        }
      } else {
        appLog('Failed to fetch bookings');
      }
    } catch (e) {
      appLog('Error fetching bookings: $e');
    } finally {
      isLoading.value = false;
    }
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
