import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/menu_drawer/saved_article/model/saved_article_course_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:get/get.dart';

class FavoriteCourseController extends GetxController {
  final _apiServices = ApiServices.instance;

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

    try {
      if (refresh) {
        currentPage.value = 1;
        savedCourses.clear();
        hasMore.value = true;
      }

      isLoading.value = true;
      appLog('Fetching saved courses - Page: ${currentPage.value}');

      final response = await _apiServices.apiGetServices(
        '${ApiEndPoints.getFavouriteArticle}?page=${currentPage.value}&limit=10&type=course',
      );

      if (response.isSuccess) {
        appLog('Saved courses fetched successfully');

        final savedResponse = SavedArticleResponse.fromJson(response.data);

        if (savedResponse.data?.allCourses != null) {
          if (refresh) {
            savedCourses.value = savedResponse.data!.allCourses!;
          } else {
            savedCourses.addAll(savedResponse.data!.allCourses!);
          }

          meta.value = savedResponse.meta;

          // Check if there are more courses
          if (savedResponse.meta != null) {
            hasMore.value =
                currentPage.value < (savedResponse.meta!.totalPage ?? 0);
          }

          appLog('Loaded ${savedCourses.length} saved courses');
        } else {
          appLog('No saved courses found');
        }
      } else {
        appLog('Failed to fetch saved courses');
      }
    } catch (e) {
      appLog('Error fetching saved courses: $e');
    } finally {
      isLoading.value = false;
    }
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

    try {
      // Store the course in case we need to revert
      final removedCourse = savedCourses[index];

      // Optimistically remove from UI
      savedCourses.removeAt(index);

      // Call API to unsave
      final response = await _apiServices.apiPostServices(
        url: ApiEndPoints.favoriteCourse,
        body: {'courseId': courseId},
      );

      if (response.isSuccess) {
        appLog('Course removed from saved list successfully');
      } else {
        // Revert on failure
        appLog('Failed to remove course - reverting');
        savedCourses.insert(index, removedCourse);
      }
    } catch (e) {
      appLog('Error removing saved course: $e');
      // Revert on error - refetch to ensure consistency
      await refreshCourses();
    }
  }

  @override
  void onClose() {
    appLog('FavoriteCourseController: Disposing controller');
    super.onClose();
  }
}
