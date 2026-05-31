import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/menu_drawer/saved_article/model/saved_article_course_model.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get.dart';

class SavedArticleController extends GetxController {
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

    if (refresh) {
      currentPage.value = 1;
      savedArticles.clear();
      hasMore.value = true;
    }

    isLoading.value = true;
    appLog('Fetching saved articles - Page: ${currentPage.value}');

    final response = await CkTransport.request<SavedArticleResponse>(
      input: RequestInput(
        endpoint:
            '${ApiEndPoints.getFavouriteArticle}?page=${currentPage.value}&limit=10&type=article',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => SavedArticleResponse.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('Saved articles fetched successfully');

      final savedResponse = response.data!;

      if (savedResponse.data?.allArticles != null) {
        if (refresh) {
          savedArticles.value = savedResponse.data!.allArticles!;
        } else {
          savedArticles.addAll(savedResponse.data!.allArticles!);
        }

        // Check if there are more articles based on length of fetched items
        hasMore.value = savedResponse.data!.allArticles!.length >= 10;

        meta.value = Meta(
          page: currentPage.value,
          limit: 10,
          total: savedArticles.length,
          totalPage: hasMore.value ? currentPage.value + 1 : currentPage.value,
        );

        appLog('Loaded ${savedArticles.length} saved articles');
      } else {
        appLog('No saved articles found');
      }
    } else {
      appLog('Failed to fetch saved articles');
    }

    isLoading.value = false;
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

    // Store the article in case we need to revert
    final removedArticle = savedArticles[index];

    // Optimistically remove from UI
    savedArticles.removeAt(index);

    // Call API to unsave
    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.toggleSaveArticle(articleId),
        method: RequestMethod.POST,
        jsonBody: {'articleId': articleId},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('Article removed from saved list successfully');
    } else {
      // Revert on failure
      appLog('Failed to remove article - reverting');
      savedArticles.insert(index, removedArticle);
    }
  }

  @override
  void onClose() {
    appLog('SavedArticleController: Disposing controller');
    super.onClose();
  }
}
