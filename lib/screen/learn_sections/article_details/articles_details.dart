import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/community_sections/main_community/controller/article_details_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ArticlesDetailsScreen extends StatefulWidget {
  const ArticlesDetailsScreen({super.key});

  @override
  State<ArticlesDetailsScreen> createState() => _ArticlesDetailsScreenState();
}

class _ArticlesDetailsScreenState extends State<ArticlesDetailsScreen> {
  late final ArticleDetailsScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ArticleDetailsScreenController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Article Details",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          // Show loading state
          if (controller.isLoading.value) {
            return Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: AppColors.primary500,
                size: 50,
              ),
            );
          }

          // Show error state if no article
          if (controller.article.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.grey100),
                  Gap(height: 16),
                  AppText(
                    text: "Article not found",
                    fontSize: 16,
                    color: AppColors.grey100,
                  ),
                  Gap(height: 16),
                  AppButton(
                    title: "Go Back",
                    onTap: () => Get.back(),
                    backgroundColor: AppColors.primary500,
                    titleColor: AppColors.white,
                    width: AppSize.width(value: 150),
                    height: AppSize.height(value: 48),
                  ),
                ],
              ),
            );
          }

          final article = controller.article.value!;

          // Build full image URL if needed
          String imageUrl = article.image ?? '';
          if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
            // If image is a relative path, prepend the base domain
            imageUrl = '${ApiEndPoints.liveDomain}$imageUrl';
          }

          return CustomScrollView(
            slivers: [
              // Image and Date Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(height: 20),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  height: AppSize.height(value: 250),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AppStaticImages.habits04,
                                      height: AppSize.height(value: 250),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                    return SizedBox(
                                          height: AppSize.height(value: 250),
                                          child: Center(
                                            child:
                                                LoadingAnimationWidget.staggeredDotsWave(
                                                  color: AppColors.primary500,
                                                  size: 40,
                                                ),
                                          ),
                                        );
                                      },
                                )
                              : Image.asset(
                                  AppStaticImages.habits04,
                                  height: AppSize.height(value: 250),
                                ),
                        ),
                      ),
                      Gap(height: 12),
                      AppText(
                        text:
                            "${article.sourseName ?? 'Unknown Source'}     --${_formatDate(article.publicationDate)}",
                        color: const Color(0xFF707070),
                        fontSize: 14,
                        fontFamilyIndex: 3,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.14,
                      ),
                    ],
                  ),
                ),
              ),

              // Pinned Title Section
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                elevation: 2,
                shadowColor: Colors.grey.withValues(alpha: 0.3),
                expandedHeight: AppSize.height(value: 100),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 20),
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                  centerTitle: false,
                  titlePadding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 20),
                    vertical: 8,
                  ),
                  title: SizedBox(
                    width: double.infinity,
                    child: AppText(
                      text: article.title ?? "Untitled Article",
                      color: Colors.black,
                      fontSize: 16,
                      fontFamilyIndex: 3,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              // Article Content Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(height: 12),
                      // Article content with See More/See Less functionality
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final description =
                              article.description ?? "No description available";

                          // Check text length when layout is built
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.checkTextLength(
                              description,
                              constraints.maxWidth,
                            );
                          });

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => AppText(
                                  text: description,
                                  color: const Color(0xFF707070),
                                  fontSize: 14,
                                  fontFamilyIndex: 3,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.14,
                                  maxLines: controller.isExpanded.value
                                      ? null
                                      : 15,
                                  textAlign: TextAlign.justify,
                                  overflow: controller.isExpanded.value
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                ),
                              ),
                              Gap(height: 8),
                              Obx(
                                () => controller.shouldShowSeeMore.value
                                    ? GestureDetector(
                                        onTap: controller.toggleExpanded,
                                        child: AppText(
                                          text: controller.isExpanded.value
                                              ? "See less"
                                              : "See more",
                                          color: AppColors.primary500,
                                          fontSize: 14,
                                          fontFamilyIndex: 3,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.14,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          );
                        },
                      ),
                      Gap(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.article.value == null) {
          return SizedBox.shrink();
        }

        return Container(
          height: AppSize.height(value: 65),
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(color: AppColors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Obx(
              () => AppButton(
                title: controller.isSaving.value
                    ? "Processing..."
                    : (controller.isSaved.value
                          ? "Remove from Saved"
                          : "Save Article"),
                titleColor: AppColors.white,
                backgroundColor: controller.isSaving.value
                    ? AppColors.grey100
                    : (controller.isSaved.value
                          ? AppColors.iconWarming
                          : AppColors.primary500),
                onTap: controller.isSaving.value
                    ? null
                    : controller.toggleSaveArticle,
                fontSize: AppSize.width(value: 12),
                height: AppSize.height(value: 48),
              ),
            ),
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Date not available";

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

    return "${months[date.month - 1]} ${date.day}${_getDaySuffix(date.day)}, ${date.year}";
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
