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
        Get.snackbar(
          "Error",
          "Failed to load article details",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      appLog('Error fetching article details: $e');
      Get.snackbar(
        "Error",
        "An error occurred while loading the article",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle the expansion state of article content
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  /// Toggle save state of the article
  void toggleSaveArticle() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Toggle save state
      isSaved.value = !isSaved.value;

      // Show success message
      Get.snackbar(
        isSaved.value ? "Saved" : "Removed",
        isSaved.value
            ? "Article saved successfully"
            : "Article removed from saved list",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: isSaved.value ? Colors.green : Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle error
      Get.snackbar(
        "Error",
        "Failed to ${isSaved.value ? 'remove' : 'save'} article",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Navigate to saved articles screen
  void navigateToSavedArticles() {
    Get.toNamed('/saved-articles');
  }

  /// Share article functionality
  void shareArticle() {
    Get.snackbar(
      "Share",
      "Share functionality would be implemented here",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
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
}
