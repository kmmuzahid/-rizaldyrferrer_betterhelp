import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/menu_drawer/saved_article/model/saved_article_course_model.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class FavoriteCourseController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;

  // Saved courses list
  final RxList<SavedCourse> savedCourses = <SavedCourse>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final Rx<Meta?> meta = Rx<Meta?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSavedCourses();
  }

  /// Fetch saved courses from API
  Future<void> fetchSavedCourses({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage.value = 1;
      savedCourses.clear();
      hasMore.value = true;
    }

    isLoading.value = true;
    appLog('Fetching saved courses - Page: ${currentPage.value}');

    final response = await DioService.instance.request<SavedArticleResponse>(
      input: RequestInput(
        endpoint:
            '${ApiEndPoints.getFavouriteArticle}?page=${currentPage.value}&limit=10&type=course',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => SavedArticleResponse.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('Saved courses fetched successfully');

      final savedResponse = response.data!;

      if (savedResponse.data?.allCourses != null) {
        if (refresh) {
          savedCourses.value = savedResponse.data!.allCourses!;
        } else {
          savedCourses.addAll(savedResponse.data!.allCourses!);
        }

        // Check if there are more courses based on length of fetched items
        hasMore.value = savedResponse.data!.allCourses!.length >= 10;

        meta.value = Meta(
          page: currentPage.value,
          limit: 10,
          total: savedCourses.length,
          totalPage: hasMore.value ? currentPage.value + 1 : currentPage.value,
        );

        appLog('Loaded ${savedCourses.length} saved courses');
      } else {
        appLog('No saved courses found');
      }
    } else {
      appLog('Failed to fetch saved courses');
    }

    isLoading.value = false;
  }

  /// Load more courses (pagination)
  Future<void> loadMoreCourses() async {
    if (!hasMore.value || isLoading.value) return;

    currentPage.value++;
    await fetchSavedCourses();
  }

  /// Refresh courses
  Future<void> refreshCourses() async {
    await fetchSavedCourses(refresh: true);
  }

  /// Remove course from saved list (optimistic update)
  Future<void> removeSavedCourse(String courseId, int index) async {
    appLog('Removing saved course: $courseId at index: $index');

    // Store the course in case we need to revert
    final removedCourse = savedCourses[index];

    // Optimistically remove from UI
    savedCourses.removeAt(index);

    // Call API to unsave
    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.favoriteCourse,
        method: RequestMethod.POST,
        jsonBody: {'courseId': courseId},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('Course removed from saved list successfully');
    } else {
      // Revert on failure
      appLog('Failed to remove course - reverting');
      savedCourses.insert(index, removedCourse);
    }
  }

  @override
  void onClose() {
    appLog('FavoriteCourseController: Disposing controller');
    super.onClose();
  }
}
