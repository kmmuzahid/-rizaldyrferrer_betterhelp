import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/learn_sections/main_learn/controller/learn_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_course_card/app_course_card.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/app_text_input/app_text_input.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LearnScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const LearnScreen({super.key, this.scaffoldKey});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late final LearnScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LearnScreenController(), permanent: false);
  }

  @override
  void dispose() {
    Get.delete<LearnScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlexibleCustomAppBar(
        title: AppString.masterclassTutorial,
        subtitle: AppString.learnAndImprove,
        leadingImagePath: AppStaticImages.learnAppbar,
        appBarHeight: AppSize.height(value: 70),
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
        onMenuTap: () => widget.scaffoldKey?.currentState?.openDrawer(),
      ),
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // Fixed content before pinned search (Carousel and indicators)
          SliverToBoxAdapter(
            child: Column(
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
                Obx(
                  () => CarouselSlider(
                    carouselController: controller.carouselController,
                    items: controller.backgroundImages.map<Widget>((imagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: RotatedBox(
                          quarterTurns: -1, // 90 degrees clockwise (use 3 for counter-clockwise)
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: AppSize.height(value: 200),
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
                ),
                // CarouselSlider(
                //   carouselController: controller.carouselController,
                //   items: controller.backgroundImages.asMap().entries.map((
                //     entry,
                //   ) {
                //     int index = entry.key;
                //     String imagePath = entry.value;
                //     return ClipRRect(
                //       borderRadius: BorderRadius.circular(12),
                //       child: Container(
                //         width: double.infinity,
                //         decoration: BoxDecoration(
                //           image: DecorationImage(
                //             image: AssetImage(imagePath),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         child: Container(
                //           padding: EdgeInsets.symmetric(
                //             horizontal: AppSize.width(value: 22),
                //             vertical: AppSize.height(value: 21),
                //           ),
                //           decoration: BoxDecoration(
                //             gradient: LinearGradient(
                //               begin: Alignment.topCenter,
                //               end: Alignment.bottomCenter,
                //               colors: [
                //                 Colors.transparent,
                //                 Colors.black.withValues(alpha: 0.3),
                //               ],
                //             ),
                //           ),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Expanded(
                //                 child: AppText(
                //                   text: controller.quoteList[index],
                //                   fontFamilyIndex: 4,
                //                   fontSize: AppSize.width(value: 16),
                //                   fontWeight: FontWeight.w500,
                //                   color: AppColors.white,
                //                   maxLines: 3,
                //                   textAlign: TextAlign.start,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //               Gap(height: 12),
                //               Align(
                //                 alignment: Alignment.centerRight,
                //                 child: AppText(
                //                   text: controller.quoteAuthorList[index],
                //                   fontFamilyIndex: 4,
                //                   fontSize: AppSize.width(value: 14),
                //                   fontWeight: FontWeight.w500,
                //                   color: AppColors.white,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   }).toList(),
                //   options: CarouselOptions(
                //     height: AppSize.height(value: 137),
                //     aspectRatio: 16 / 9,
                //     viewportFraction: 0.85,
                //     initialPage: 0,
                //     enableInfiniteScroll: true,
                //     autoPlay: true,
                //     autoPlayInterval: const Duration(seconds: 4),
                //     autoPlayAnimationDuration: const Duration(
                //       milliseconds: 800,
                //     ),
                //     autoPlayCurve: Curves.linear,
                //     enlargeCenterPage: true,
                //     enlargeFactor: 0.2,
                //     scrollDirection: Axis.horizontal,
                //     onPageChanged: (index, reason) {
                //       controller.updateCurrentIndex(index);
                //     },
                //   ),
                // ),
                Gap(height: 16),
                Center(
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        controller.backgroundImages.length,
                        (index) {
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
                        },
                      ),
                    ),
                  ),
                ),
                Gap(height: 16),
                //! Categories Section
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
                  child: Obx(() {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
                      itemCount: controller.categoryList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoute.trendingCourse,
                              arguments: {
                                  'categoryName': controller.categoryList[index].name},
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
                                CommonImage(src: controller.categoryList[index].image, size: 32),
                                Gap(height: 4),
                                Expanded(
                                  child: AppText(
                                    text: controller.categoryList[index].name,
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
                    );
                  }
                  ),
                ),
                Gap(height: 20),
              ],
            ),
          ),

          //! Trending Courses Section - As Sliver
          SliverToBoxAdapter(
            child: Padding(
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
          ),

          SliverToBoxAdapter(child: Gap(height: 12)),

          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSize.height(value: 250),
              child: Obx(() {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
                  itemCount: controller.trendingCourseList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: AppSize.width(value: 240),
                      margin: EdgeInsets.only(right: AppSize.width(value: 16)),
                      child: CourseCard(
                        onTap: () {
                          Get.toNamed(
                            AppRoute.courseDetailScreen,
                            arguments: {'id': controller.trendingCourseList[index].id},
                          );
                        },
                        imageUrl: controller.trendingCourseList[index].thumbnail,
                        title: controller.trendingCourseList[index].title,
                        instructor: controller.trendingCourseList[index].categoryName,
                        rating: controller.trendingCourseList[index].rating,
                        views: "${controller.trendingCourseList[index].viewUsers.length} views",
                        date: CoreUtils.formatDateTime(
                          controller.trendingCourseList[index].createdAt,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          SliverToBoxAdapter(child: Gap(height: 20)),

          //! Recent Course Section - As Sliver
          SliverToBoxAdapter(
            child: Padding(
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
          ),

          SliverToBoxAdapter(child: Gap(height: 12)),

          SliverToBoxAdapter(
            child: SizedBox(
              height: AppSize.height(value: 250),
              child: Obx(() {
                return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(value: 20),
                ),
                  itemCount: controller.recentCourseList.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 240,
                    height: AppSize.height(value: 300),
                    margin: EdgeInsets.only(right: AppSize.width(value: 16)),
                    child: CourseCard(
                        onTap: () {
                          Get.toNamed(
                            AppRoute.courseDetailScreen,
                            arguments: {'id': controller.recentCourseList[index].id},
                          );
                        },
                        imageUrl: controller.recentCourseList[index].thumbnail,
                        title: controller.recentCourseList[index].title,
                        instructor: controller.recentCourseList[index].categoryName,
                        rating: controller.recentCourseList[index].rating,
                        views: "${controller.recentCourseList[index].viewUsers.length} views",
                        date: CoreUtils.formatDateTime(
                          controller.recentCourseList[index].createdAt,
                        ),
                      ),
                  );
                },
                );
              }),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
