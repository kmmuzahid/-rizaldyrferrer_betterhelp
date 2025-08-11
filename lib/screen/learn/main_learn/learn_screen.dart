import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/learn/main_learn/controller/learn_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LearnScreenController controller = Get.put(LearnScreenController());

    return Scaffold(
      appBar: FlexibleCustomAppBar(
        title: AppString.masterclassTutorial,
        subtitle: AppString.learnAndImprove,
        leadingImagePath: AppStaticImages.learnAppbar,
        appBarHeight: AppSize.height(value: 70),
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: AppTextInput(
                prefixIcon: Icons.search,
                hintText: "Search courses...",
                height: AppSize.height(value: 48),
                backgroundColor: AppColors.white,
                borderColor: AppColors.black10,
              ),
            ),
            Gap(height: 15),
            CarouselSlider(
              carouselController: controller.carouselController,
              items: controller.backgroundImages.asMap().entries.map((entry) {
                int index = entry.key;
                String imagePath = entry.value;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 22),
                        vertical: AppSize.height(value: 21),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppText(
                              text: controller.quoteList[index],
                              fontFamilyIndex: 4,
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppText(
                              text: controller.quoteAuthorList[index],
                              fontFamilyIndex: 4,
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: AppSize.height(value: 137),
                aspectRatio: 16 / 9,
                viewportFraction: 0.85,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.linear,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  controller.updateCurrentIndex(index);
                },
              ),
            ),
            Gap(height: 16),
            Center(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(controller.backgroundImages.length, (
                    index,
                  ) {
                    return GestureDetector(
                      onTap: () => controller.goToSlide(index),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppSize.width(value: 3),
                        ),
                        height: AppSize.height(value: 8),
                        width: AppSize.width(value: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.5),
                          color: controller.currentIndex.value == index
                              ? AppColors.secondary900
                              : AppColors.iconLightgrey,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            //! Categories Section
            Gap(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.height(value: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Categories",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoute.allCategoriesScreen);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: AppText(
                      text: "See all",
                      color: AppColors.blue500,
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue500,
                    ),
                  ),
                ],
              ),
            ),
            Gap(height: 08),
            SizedBox(
              height: AppSize.height(value: 95),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                itemCount: controller.categoryImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoute.trendingCourse,
                        arguments: {
                          'categoryName': controller.categoryNames[index],
                        },
                      );
                    },
                    child: Container(
                      width: AppSize.width(value: 88),
                      margin: EdgeInsets.only(right: AppSize.width(value: 12)),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.red50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            controller.categoryImages[index],
                            height: AppSize.height(value: 32),
                            width: AppSize.width(value: 32),
                          ),
                          Gap(height: 4),
                          Expanded(
                            child: AppText(
                              text: controller.categoryNames[index],
                              fontFamilyIndex: 2,
                              fontSize: AppSize.width(value: 12),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimaryBlack,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Gap(height: 20),

            //! Trending Courses Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Trending Courses",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500,
                  ),
                  InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.toNamed(AppRoute.trendingCourse);
                    },
                    child: AppText(
                      text: "See all",
                      color: AppColors.blue500,
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue500,
                    ),
                  ),
                ],
              ),
            ),
            Gap(height: 12),
            SizedBox(
              height: AppSize.height(value: 250),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                itemCount: controller.trendingCourseImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: AppSize.width(value: 240),
                    margin: EdgeInsets.only(right: AppSize.width(value: 16)),
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
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryBlack,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(height: 4),
                              AppText(
                                text:
                                    controller.trendingCourseInstructors[index],
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
                                    text: controller
                                        .trendingCourseRatings[index]
                                        .toString(),
                                    fontSize: AppSize.width(value: 14),
                                    color: AppColors.grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Gap(height: 20),
            //! Recent Course
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Recent Course",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey500,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoute.trendingCourse);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.indigo,
                    child: AppText(
                      text: "See all",
                      color: AppColors.blue500,
                      fontFamilyIndex: 2,
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue500,
                    ),
                  ),
                ],
              ),
            ),
            Gap(height: 12),
            SizedBox(
              height: AppSize.height(value: 250),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                itemCount: controller.trendingCourseImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: AppSize.width(value: 240),
                    margin: EdgeInsets.only(right: AppSize.width(value: 16)),
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
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryBlack,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                fontFamilyIndex: 2,
                              ),
                              Gap(height: 4),
                              AppText(
                                text:
                                    controller.trendingCourseInstructors[index],
                                fontSize: AppSize.width(value: 14),
                                color: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                                fontFamilyIndex: 2,
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
                                    text: controller
                                        .trendingCourseRatings[index]
                                        .toString(),
                                    fontSize: AppSize.width(value: 14),
                                    color: AppColors.grey500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Gap(height: 100),
          ],
        ),
      ),
    );
  }
}
