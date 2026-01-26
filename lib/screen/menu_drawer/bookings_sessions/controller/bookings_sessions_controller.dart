import 'package:better_help/screen/menu_drawer/bookings_sessions/model/bookings_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:get/get.dart';

class BookingsSessionsController extends GetxController {
  final _apiServices = ApiServices.instance;

  // Loading state
  final RxBool isLoading = false.obs;

  // Bookings list
  final RxList<BookingsModel> bookings = <BookingsModel>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final Rx<BookingMeta?> meta = Rx<BookingMeta?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
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
        '${AppApiurl.seeAllBookings}?page=${currentPage.value}&limit=10',
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
