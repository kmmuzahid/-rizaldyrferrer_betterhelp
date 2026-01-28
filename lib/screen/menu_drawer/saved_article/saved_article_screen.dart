import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/saved_article/controller/saved_article_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_course_card/app_course_card.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SavedArticleScreen extends GetView<SavedArticleController> {
  const SavedArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Saved Articles",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: Obx(() {
        // Show loading for initial load
        if (controller.isLoading.value && controller.savedArticles.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: AppColors.primary500,
              size: 50,
            ),
          );
        }

        // Show empty state
        if (controller.savedArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: AppColors.grey100),
                Gap(height: 16),
                AppText(
                  text: "No saved articles yet",
                  fontSize: 16,
                  color: AppColors.grey100,
                  fontWeight: FontWeight.w500,
                ),
                Gap(height: 8),
                AppText(
                  text: "Articles you save will appear here",
                  fontSize: 14,
                  color: AppColors.grey100,
                ),
              ],
            ),
          );
        }

        // Show articles list
        return RefreshIndicator(
          onRefresh: controller.refreshArticles,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 20),
              vertical: AppSize.height(value: 10),
            ),
            itemCount:
                controller.savedArticles.length +
                (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the end
              if (index == controller.savedArticles.length) {
                if (controller.hasMore.value) {
                  // Trigger load more
                  Future.microtask(() => controller.loadMoreArticles());
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.height(value: 20),
                    ),
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.primary500,
                        size: 40,
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }

              final savedArticle = controller.savedArticles[index];
              final article = savedArticle.articleId;

              if (article == null) return SizedBox.shrink();

              // Build full image URL
              String imageUrl = article.image ?? '';
              if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                imageUrl = '${ApiEndPoints.liveDomain}$imageUrl';
              }

              // Parse publication date
              String formattedDate = "Date not available";
              if (article.publicationDate != null) {
                try {
                  final date = DateTime.parse(article.publicationDate!);
                  formattedDate =
                      "${date.day} ${_getMonthName(date.month)}, ${date.year}";
                } catch (e) {
                  formattedDate = article.publicationDate!;
                }
              }

              return Padding(
                padding: EdgeInsets.only(bottom: AppSize.height(value: 12)),
                child: CourseCard(
                  onTap: () {
                    Get.toNamed(
                      AppRoute.articleScreen,
                      arguments: {'articleId': article.id},
                    );
                  },
                  margin: EdgeInsets.only(bottom: 10),
                  cardType: CardType.article,
                  height: AppSize.height(value: 245),
                  title: article.title ?? "Untitled Article",
                  instructor: article.sourseName ?? "Unknown Author",
                  timeToread: article.readTime ?? "5 minutes to read",
                  date: formattedDate,
                  imageUrl: imageUrl.isNotEmpty
                      ? imageUrl
                      : AppStaticImages.habits01,
                  isFavorited: true,
                  onFavoritePressed: () {
                    if (article.id != null) {
                      controller.removeSavedArticle(article.id!, index);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
