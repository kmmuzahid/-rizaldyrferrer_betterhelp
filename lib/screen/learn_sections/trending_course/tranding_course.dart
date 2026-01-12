import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/learn_sections/main_learn/model/course_model.dart';
import 'package:better_help/screen/learn_sections/trending_course/controller/trending_course_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrandingCourse extends StatelessWidget {
  final String? categoryName;

  const TrandingCourse({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    final TrendingCourseController controller = Get.put(TrendingCourseController());

    // Get category name from arguments if not provided directly
    final String displayTitle =
        categoryName ??
        Get.arguments?['categoryName'] ??
        Get.arguments?['title'] ??
        "Trending Course";

    if (Get.arguments?['isSearch'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).nextFocus();
        });
      });
    }

    return Scaffold(
      appBar: AppBarWithBack(text: displayTitle, backgroundColor: AppColors.white),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () => SmartListLoader(
            appbar: search(controller),
            onColapsAppbar: search(controller),
            isLoading: controller.isLoading.value,
            onRefresh: () {
              controller.searchController.text = '';
              controller.lastSearch = '';
              controller.trendingCourseList.clear();
              controller.fetchTrendingCourse(page: 1);
            },
            limit: 10,
            onLoadMore: (page) {
              controller.fetchTrendingCourse(page: page + 1);
            },
            itemCount: controller.trendingCourseList.length,
            itemBuilder: (context, index) {
              final course = controller.trendingCourseList[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.courseDetailScreen, arguments: {'id': course.id});
                },
                child: _itemBuilder(index, course, controller),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget search(TrendingCourseController controller) {
    return AppTextInput(
      controller: controller.searchController,
      prefixIcon: Icons.search,
      hintText: "Search course",
      height: AppSize.height(value: 48),
      backgroundColor: AppColors.white,
      borderColor: AppColors.black10,
      borderSide: BorderSide(color: AppColors.black10),
    );
  }

  Container _itemBuilder(int index, CourseModel course, TrendingCourseController controller) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppSize.width(value: 16),
        top: index == 0 ? 15 : 0, // Add top margin only for first item
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
              CommonImage(src: course.thumbnail, height: 140, width: double.infinity),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    controller.toggleFavoriteCourse(index);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      course.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: course.isFavorite ? Colors.pink : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    fontFamilyIndex: 2,
                    text: course.viewCont.toString(),
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
                  text: course.title,
                  fontSize: AppSize.width(value: 16),
                  fontFamilyIndex: 2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryBlack,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(height: 4),
                AppText(
                  text: course.categoryName,
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
                          starIndex < course.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    Gap(width: 4),
                    AppText(
                      text: course.rating.toString(),
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
  }
}
