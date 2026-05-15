import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/menu_drawer/saved_article/model/saved_article_course_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:get/get.dart';

class SavedArticleController extends GetxController {
  final _apiServices = ApiServices.instance;

  // Loading state
  final RxBool isLoading = false.obs;

  // Saved articles list
  final RxList<SavedArticle> savedArticles = <SavedArticle>[].obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final Rx<Meta?> meta = Rx<Meta?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSavedArticles();
  }

  /// Fetch saved articles from API
  Future<void> fetchSavedArticles({bool refresh = false}) async {
    if (isLoading.value) return;

    try {
      if (refresh) {
        currentPage.value = 1;
        savedArticles.clear();
        hasMore.value = true;
      }

      isLoading.value = true;
      appLog('Fetching saved articles - Page: ${currentPage.value}');

      final response = await _apiServices.apiGetServices(
        '${ApiEndPoints.getFavouriteArticle}?page=${currentPage.value}&limit=10&type=article',
      );

      if (response.isSuccess) {
        appLog('Saved articles fetched successfully');

        final savedResponse = SavedArticleResponse.fromJson(response.data);

        if (savedResponse.data?.allArticles != null) {
          if (refresh) {
            savedArticles.value = savedResponse.data!.allArticles!;
          } else {
            savedArticles.addAll(savedResponse.data!.allArticles!);
          }

          meta.value = savedResponse.meta;

          // Check if there are more articles
          if (savedResponse.meta != null) {
            hasMore.value =
                currentPage.value < (savedResponse.meta!.totalPage ?? 0);
          }

          appLog('Loaded ${savedArticles.length} saved articles');
        } else {
          appLog('No saved articles found');
        }
      } else {
        appLog('Failed to fetch saved articles');
      }
    } catch (e) {
      appLog('Error fetching saved articles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more articles (pagination)
  Future<void> loadMoreArticles() async {
    if (!hasMore.value || isLoading.value) return;

    currentPage.value++;
    await fetchSavedArticles();
  }

  /// Refresh articles
  Future<void> refreshArticles() async {
    await fetchSavedArticles(refresh: true);
  }

  /// Remove article from saved list (optimistic update)
  Future<void> removeSavedArticle(String articleId, int index) async {
    appLog('Removing saved article: $articleId at index: $index');

    try {
      // Store the article in case we need to revert
      final removedArticle = savedArticles[index];

      // Optimistically remove from UI
      savedArticles.removeAt(index);

      // Call API to unsave
      final response = await _apiServices.apiPostServices(
        url: ApiEndPoints.toggleSaveArticle(articleId),
        body: {'articleId': articleId},
      );

      if (response.isSuccess) {
        appLog('Article removed from saved list successfully');
      } else {
        // Revert on failure
        appLog('Failed to remove article - reverting');
        savedArticles.insert(index, removedArticle);
      }
    } catch (e) {
      appLog('Error removing saved article: $e');
      // Revert on error - refetch to ensure consistency
      await refreshArticles();
    }
  }

  @override
  void onClose() {
    appLog('SavedArticleController: Disposing controller');
    super.onClose();
  }
}
