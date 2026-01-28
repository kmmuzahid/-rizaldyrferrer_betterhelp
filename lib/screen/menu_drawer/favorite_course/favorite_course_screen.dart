import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/favorite_course/controller/favorite_course_controller.dart';
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

class FavoriteCourseScreen extends GetView<FavoriteCourseController> {
  const FavoriteCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Favorite Courses",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: Obx(() {
        // Show loading for initial load
        if (controller.isLoading.value && controller.savedCourses.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: AppColors.primary500,
              size: 50,
            ),
          );
        }

        // Show empty state
        if (controller.savedCourses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: AppColors.grey100),
                Gap(height: 16),
                AppText(
                  text: "No favorite courses yet",
                  fontSize: 16,
                  color: AppColors.grey100,
                  fontWeight: FontWeight.w500,
                ),
                Gap(height: 8),
                AppText(
                  text: "Courses you favorite will appear here",
                  fontSize: 14,
                  color: AppColors.grey100,
                ),
              ],
            ),
          );
        }

        // Show courses list
        return RefreshIndicator(
          onRefresh: controller.refreshCourses,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 20),
              vertical: AppSize.height(value: 10),
            ),
            itemCount:
                controller.savedCourses.length +
                (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the end
              if (index == controller.savedCourses.length) {
                if (controller.hasMore.value) {
                  // Trigger load more
                  Future.microtask(() => controller.loadMoreCourses());
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

              final savedCourse = controller.savedCourses[index];
              final course = savedCourse.courseId;

              if (course == null) return SizedBox.shrink();

              // Build full image URL
              String imageUrl = course.thumbnail ?? '';
              if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                imageUrl = '${ApiEndPoints.liveDomain}$imageUrl';
              }

              // Format view count
              String viewCount = "${course.viewCount ?? 0} views";

              return Padding(
                padding: EdgeInsets.only(bottom: AppSize.height(value: 12)),
                child: CourseCard(
                  onTap: () {
                    Get.toNamed(
                      AppRoute.courseDetailScreen,
                      arguments: {'courseId': course.id},
                    );
                  },
                  margin: EdgeInsets.only(bottom: 10),
                  cardType: CardType.course,
                  height: AppSize.height(value: 247),
                  title: course.title ?? "Untitled Course",
                  instructor: course.categoryName ?? "Unknown Category",
                  rating: course.ratings ?? 0.0,
                  views: viewCount,
                  imageUrl: imageUrl.isNotEmpty
                      ? imageUrl
                      : AppStaticImages.habits01,
                  isFavorited: true,
                  onFavoritePressed: () {
                    if (course.id != null) {
                      controller.removeSavedCourse(course.id!, index);
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
}
