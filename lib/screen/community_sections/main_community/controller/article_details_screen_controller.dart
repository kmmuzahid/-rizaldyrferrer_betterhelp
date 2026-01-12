import 'package:better_help/screen/community_sections/main_community/model/article_model.dart';
import 'package:better_help/service/repository/community_repository/community_repository.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleDetailsScreenController extends GetxController {
  final _repository = CommunityRepository();

  // Observable for tracking if article content is expanded
  final RxBool isExpanded = false.obs;

  // Observable for tracking if article is saved
  final RxBool isSaved = false.obs;

  // Loading state
  final RxBool isLoading = true.obs;

  // Loading state for save operation
  final RxBool isSaving = false.obs;

  // Observable to check if "See more" should be shown
  final RxBool shouldShowSeeMore = false.obs;

  // Article data
  final Rx<Datum?> article = Rx<Datum?>(null);

  // Text style for measuring text (matching AppText style)
  final TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.14,
    height: 1.4,
  );

  @override
  void onInit() {
    super.onInit();
    // Get article ID from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final articleId = args?['articleId'] as String?;

    if (articleId != null) {
      fetchArticleDetails(articleId);
    } else {
      appLog('No article ID provided');
      isLoading.value = false;
    }
  }

  /// Fetch article details
  Future<void> fetchArticleDetails(String articleId) async {
    try {
      isLoading.value = true;
      appLog('Fetching article details for ID: $articleId');

      final result = await _repository.getSingleArticle(articleId);

      if (result != null) {
        article.value = result;
        isSaved.value = result.isFavorite ?? false;
        appLog('Article details fetched successfully');
      } else {
        appLog('Failed to fetch article details');
      }
    } catch (e) {
      appLog('Error fetching article details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle the expansion state of article content
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  /// Toggle save state of the article
  Future<void> toggleSaveArticle() async {
    if (article.value == null || isSaving.value) return;

    try {
      final articleId = article.value!.id;
      if (articleId == null) {
        appLog('Cannot save article: Article ID is null');
        return;
      }

      // Prevent multiple simultaneous calls
      isSaving.value = true;

      // Optimistically update UI
      final previousState = isSaved.value;
      isSaved.value = !isSaved.value;

      // Update the article's isFavorite field
      article.value = Datum(
        id: article.value!.id,
        title: article.value!.title,
        description: article.value!.description,
        image: article.value!.image,
        publicationDate: article.value!.publicationDate,
        sourseName: article.value!.sourseName,
        readTime: article.value!.readTime,
        isDeleted: article.value!.isDeleted,
        createdAt: article.value!.createdAt,
        updatedAt: article.value!.updatedAt,
        isFavorite: isSaved.value,
      );

      appLog('Calling API to toggle save state for article: $articleId');

      // Call API
      final success = await _repository.toggleSaveArticle(articleId);

      appLog('API response: $success');

      if (!success) {
        // Revert on failure
        appLog('Failed to toggle save state - reverting');
        isSaved.value = previousState;
        article.value = Datum(
          id: article.value!.id,
          title: article.value!.title,
          description: article.value!.description,
          image: article.value!.image,
          publicationDate: article.value!.publicationDate,
          sourseName: article.value!.sourseName,
          readTime: article.value!.readTime,
          isDeleted: article.value!.isDeleted,
          createdAt: article.value!.createdAt,
          updatedAt: article.value!.updatedAt,
          isFavorite: previousState,
        );
      } else {
        appLog('Article save state toggled successfully');
      }
    } catch (e) {
      appLog('Error toggling save state: $e');
      // Revert on error
      final previousState = !isSaved.value;
      isSaved.value = previousState;
    } finally {
      if (!isClosed) {
        isSaving.value = false;
      }
    }
  }

  /// Navigate to saved articles screen
  void navigateToSavedArticles() {
    Get.toNamed('/saved-articles');
  }

  /// Share article functionality
  void shareArticle() {
    appLog('Share article functionality would be implemented here');
  }

  /// Check if text needs "See more" button
  void checkTextLength(String text, double width) {
    final textPainterCollapsed = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 15,
      textDirection: TextDirection.ltr,
    );
    textPainterCollapsed.layout(maxWidth: width);

    shouldShowSeeMore.value = textPainterCollapsed.didExceedMaxLines;
  }

  @override
  void onClose() {
    appLog('ArticleDetailsScreenController: Disposing controller');
    super.onClose();
  }
}
