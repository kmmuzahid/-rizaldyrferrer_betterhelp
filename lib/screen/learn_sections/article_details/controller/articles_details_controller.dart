import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesDetailsController extends GetxController {
  // Observable for tracking if article content is expanded
  final RxBool isExpanded = false.obs;

  // Observable for tracking if article is saved
  final RxBool isSaved = false.obs;

  // Loading state for save operation
  final RxBool isLoading = false.obs;

  // Observable to check if "See more" should be shown
  final RxBool shouldShowSeeMore = false.obs;

  // Text style for measuring text (matching AppText style)
  final TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.14,
    height: 1.4, // Line height for better text measurement
  );

  /// Toggle the expansion state of article content
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  /// Toggle save state of the article
  void toggleSaveArticle() async {
    try {
      isLoading.value = true;

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
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to saved articles screen
  void navigateToSavedArticles() {
    // Replace with your actual route
    Get.toNamed('/saved-articles');
  }

  /// Share article functionality
  void shareArticle() {
    // Implement share functionality
    Get.snackbar(
      "Share",
      "Share functionality would be implemented here",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Check if text needs "See more" button
  void checkTextLength(String text, double width) {
    // Create text painter for 15 lines (collapsed state)
    final textPainterCollapsed = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 15, // Check against 15 lines
      textDirection: TextDirection.ltr,
    );
    textPainterCollapsed.layout(maxWidth: width);

    // Create text painter for full text (no line limit)
    final textPainterFull = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainterFull.layout(maxWidth: width);

    // Show "See more" if full text height is greater than 15-line height
    shouldShowSeeMore.value =
        textPainterFull.height > textPainterCollapsed.height;

    appLog(
      'Text check: Full height: ${textPainterFull.height}, Collapsed height: ${textPainterCollapsed.height}',
    );
    debugPrint('Should show see more: ${shouldShowSeeMore.value}');
  }

  /// Get expanded state
  bool get isArticleExpanded => isExpanded.value;

  /// Get save state
  bool get isArticleSaved => isSaved.value;

  /// Get loading state
  bool get isSaving => isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize any data or listeners here
    debugPrint('ArticlesDetailsController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered on screen
    debugPrint('ArticlesDetailsController ready');

    // Check text length after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // You can call checkTextLength here with the actual text and width
      // Example: checkTextLength(AppString.demoArticleDetails, Get.width - 40);
    });
  }

  @override
  void onClose() {
    debugPrint('ArticlesDetailsController disposed');
    super.onClose();
  }
}
