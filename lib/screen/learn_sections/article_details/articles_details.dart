import 'package:better_help/screen/learn_sections/article_details/controller/articles_details_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesDetailsScreen extends StatelessWidget {
  const ArticlesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final ArticlesDetailsController controller = Get.put(
      ArticlesDetailsController(),
    );

    return Scaffold(
      appBar: AppBarWithBack(
        text: "Article Details",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: CustomScrollView(
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
                      child: Image.asset(
                        AppStaticImages.habits04,
                        height: AppSize.height(value: 250),
                      ),
                    ),
                  ),
                  Gap(height: 12),
                  AppText(
                    text: "The Daily Star     --May 12th, 2025",
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
                  text: "What's causing E. Coli Outbreaks? ",
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
                      // Check text length when layout is built
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.checkTextLength(
                          AppString.demoArticleDetails,
                          constraints.maxWidth,
                        );
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => AppText(
                              text: AppString.demoArticleDetails,
                              color: const Color(0xFF707070),
                              fontSize: 14,
                              fontFamilyIndex: 3,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.14,
                              maxLines: controller.isExpanded.value
                                  ? null
                                  : 15, // Show 15 lines when collapsed
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: AppSize.height(value: 80),
        decoration: BoxDecoration(color: AppColors.white),
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppButton(
              title: controller.isLoading.value
                  ? "Saving..."
                  : "Saved Articles",
              titleColor: AppColors.white,
              backgroundColor: controller.isLoading.value
                  ? AppColors.primary500.withValues(alpha: 0.7)
                  : AppColors.primary500,
              onTap: controller.isLoading.value
                  ? null
                  : controller.toggleSaveArticle,
              fontSize: AppSize.width(value: 12),
              height: AppSize.height(value: 48),
            ),
          ),
        ),
      ),
    );
  }
}
