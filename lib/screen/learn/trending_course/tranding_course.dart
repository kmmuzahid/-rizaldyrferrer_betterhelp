import 'package:better_help/screen/learn/trending_course/controller/trending_course_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrandingCourse extends StatelessWidget {
  final String? categoryName;

  const TrandingCourse({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    final TrendingCourseController controller = Get.put(
      TrendingCourseController(),
    );

    // Get category name from arguments if not provided directly
    final String displayTitle =
        categoryName ?? Get.arguments?['categoryName'] ?? "Trending Course";

    return Scaffold(
      appBar: AppBarWithBack(
        text: displayTitle,
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // Pinned Search Bar
          SliverAppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            pinned: true,
            floating: false,
            snap: false,
            automaticallyImplyLeading: false,
            toolbarHeight: AppSize.height(
              value: 78,
            ), // 48 + 30 (15 top + 15 bottom padding)
            flexibleSpace: Container(
              color: AppColors.white,
              padding: EdgeInsets.only(
                left: AppSize.width(value: 20),
                right: AppSize.width(value: 20),
                top: 15,
                bottom: 15,
              ),
              child: AppTextInput(
                prefixIcon: Icons.search,
                hintText: "Search categories",
                height: AppSize.height(value: 48),
                backgroundColor: AppColors.white,
                borderColor: AppColors.black10,
                borderSide: BorderSide(color: AppColors.black10),
              ),
            ),
          ),

          //! Course List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    bottom: AppSize.width(value: 16),
                    top: index == 0
                        ? 15
                        : 0, // Add top margin only for first item
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.t5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              controller.trendingCourseImages[index],
                              height: AppSize.height(value: 140),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AppText(
                                fontFamilyIndex: 2,
                                text: controller.trendingCourseViews[index],
                                fontSize: AppSize.width(value: 12),
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: controller.trendingCourseTitles[index],
                              fontSize: AppSize.width(value: 16),
                              fontFamilyIndex: 2,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryBlack,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Gap(height: 4),
                            AppText(
                              text: controller.trendingCourseInstructors[index],
                              fontFamilyIndex: 2,
                              fontSize: AppSize.width(value: 14),
                              color: AppColors.grey500,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap(height: 8),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex <
                                              controller
                                                  .trendingCourseRatings[index]
                                                  .floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  }),
                                ),
                                Gap(width: 4),
                                AppText(
                                  text: controller.trendingCourseRatings[index]
                                      .toString(),
                                  fontSize: AppSize.width(value: 14),
                                  color: AppColors.grey500,
                                  fontWeight: FontWeight.w500,
                                  fontFamilyIndex: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: 10),
            ),
          ),
        ],
      ),
    );
  }
}
