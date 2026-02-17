import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/learn_sections/main_learn/controller/learn_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
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
    controller = Get.find<LearnScreenController>();
  }

  @override
  void dispose() {
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
                  padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.toNamed(
                        AppRoute.trendingCourse,
                        arguments: {'title': 'Search Courses', 'isSearch': true},
                      );
                    },
                    child: AbsorbPointer(
                      child: CommonTextField(
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search courses...",
                        validationType: ValidationType.notRequired,
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.black10,
                      ),
                    ),
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
             
                Gap(height: 16),
                Center(
                  child: Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(controller.backgroundImages.length, (index) {
                        return GestureDetector(
                          onTap: () => controller.goToSlide(index),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 3)),
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
                Gap(height: 16),
                //! Categories Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.height(value: 20)),
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
                    
                    ],
                  ),
                ),
              
                Gap(height: 20),
              ],
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            sliver: Obx(
              () => controller.isCategoryLoading.value
                  ? SliverToBoxAdapter(child: const Center(child: CircularProgressIndicator()))
                  : SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: .95,
                      ),
                      itemCount: controller.categoryList.length,
                      itemBuilder: (context, index) {
                        return _category(index);
                      },
                    ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  GestureDetector _category(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoute.trendingCourse,
          arguments: {'category': controller.categoryList[index]},
        );
      },
      child: Container(
        width: AppSize.width(value: 88),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.red50, borderRadius: BorderRadius.circular(10)),
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
  }
}
