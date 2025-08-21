import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/community_sections/main_community/controller/community_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_button/app_button_with_icon.dart';
import 'package:better_help/widget/app_button/selectable_icon_app_button.dart'
    hide CustomIconAlignment;
import 'package:better_help/widget/app_comments_widget/app_comments_widget.dart';
import 'package:better_help/widget/app_course_card/app_course_card.dart';
import 'package:better_help/widget/app_post_card/app_post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CommunityScreen({super.key, this.scaffoldKey});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late final CommunityScreenController controller;

  @override
  void initState() {
    super.initState();
    // Use Get.put with permanent: false to allow disposal
    controller = Get.put(CommunityScreenController(), permanent: false);
  }

  @override
  void dispose() {
    // Clean up controller when screen is disposed
    Get.delete<CommunityScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> articleImages = [
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
      AppStaticImages.habits01,
      AppStaticImages.habits02,
      AppStaticImages.habits03,
      AppStaticImages.habits04,
    ];
    return Scaffold(
      appBar: FlexibleCustomAppBar(
        title: AppString.communities,
        subtitle: AppString.engageWithLikeMindedPeople,
        leadingImagePath: AppStaticImages.communityAppbar,
        appBarHeight: AppSize.height(value: 70),
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
        onMenuTap: () => widget.scaffoldKey?.currentState?.openDrawer(),
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              GetBuilder<CommunityScreenController>(
                builder: (controller) => SliverAppBar(
                  pinned: true,
                  expandedHeight: controller.selectedTab == CommunityTab.article
                      ? AppSize.height(value: 70)
                      : AppSize.height(value: 115),
                  collapsedHeight:
                      controller.selectedTab == CommunityTab.article
                      ? AppSize.height(value: 70)
                      : AppSize.height(value: 115),
                  backgroundColor: AppColors.white,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    color: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<CommunityScreenController>(
                          builder: (controller) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //! Peer Forum Button
                              IconAppButton(
                                title: "Peer Forum",
                                fontSize: 12,
                                iconSize: 15,
                                titleColor:
                                    controller.isTabSelected(
                                      CommunityTab.peerForum,
                                    )
                                    ? AppColors.white
                                    : AppColors.black,
                                backgroundColor:
                                    controller.isTabSelected(
                                      CommunityTab.peerForum,
                                    )
                                    ? AppColors.t3
                                    : AppColors.white500,
                                borderColor: AppColors.grey100,
                                borderRadius: 12,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.width(value: 10),
                                  vertical: AppSize.height(value: 5.5),
                                ),
                                height: AppSize.width(value: 36),
                                width: AppSize.height(value: 165),
                                icon: AppStaticImages.peerforum,
                                iconAlignment: CustomIconAlignment.left,
                                // Add this missing onTap callback
                                onTap: () => controller.selectTab(
                                  CommunityTab.peerForum,
                                ),
                              ),
                              //! Article Button
                              IconAppButton(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.width(value: 10),
                                  vertical: AppSize.height(value: 5.5),
                                ),
                                iconAlignment: CustomIconAlignment.left,
                                icon: AppStaticImages.communityArticle,
                                height: AppSize.width(value: 36),
                                width: AppSize.height(value: 165),
                                fontSize: 12,
                                iconSize: 15,
                                title: "Article",
                                backgroundColor:
                                    controller.isTabSelected(
                                      CommunityTab.article,
                                    )
                                    ? AppColors.t3
                                    : AppColors.white500,
                                titleColor:
                                    controller.isTabSelected(
                                      CommunityTab.article,
                                    )
                                    ? AppColors.white
                                    : AppColors.black,
                                onTap: () =>
                                    controller.selectTab(CommunityTab.article),
                                borderColor: AppColors.grey100,
                                borderRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        Gap(height: 15),
                        // Only show filter buttons for Peer Forum
                        GetBuilder<CommunityScreenController>(
                          builder: (controller) =>
                              controller.selectedTab == CommunityTab.peerForum
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //! Recent Button
                                    IconAppButton(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.width(value: 08),
                                        vertical: AppSize.height(value: 5.5),
                                      ),
                                      iconAlignment: CustomIconAlignment.left,
                                      icon: AppStaticImages.communityRecent,
                                      borderRadius: 12,
                                      height: AppSize.width(value: 36),
                                      width: AppSize.height(value: 110),
                                      fontSize: 12,
                                      iconSize: 15,
                                      title: "Recent",
                                      backgroundColor:
                                          controller.isFilterSelected(
                                            ForumFilter.recent,
                                          )
                                          ? AppColors.iconWarming
                                          : AppColors.white500,
                                      titleColor: AppColors.black,
                                      onTap: () => controller.selectFilter(
                                        ForumFilter.recent,
                                      ),
                                    ),
                                    //! Highlight Button
                                    IconAppButton(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.width(value: 10),
                                        vertical: AppSize.height(value: 5.5),
                                      ),
                                      iconAlignment: CustomIconAlignment.left,
                                      icon: AppStaticImages.communityHighlight,
                                      height: AppSize.width(value: 36),
                                      width: AppSize.height(value: 140),
                                      fontSize: 12,
                                      iconSize: 15,
                                      title: "Highlight",
                                      backgroundColor:
                                          controller.isFilterSelected(
                                            ForumFilter.highlight,
                                          )
                                          ? AppColors.iconWarming
                                          : AppColors.white500,
                                      titleColor: AppColors.black,
                                      onTap: () => controller.selectFilter(
                                        ForumFilter.highlight,
                                      ),
                                      borderColor: AppColors.grey100,
                                      borderRadius: 12,
                                    ),
                                    //! Popular Button
                                    IconAppButton(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.width(value: 05),
                                        vertical: AppSize.height(value: 5.5),
                                      ),
                                      iconAlignment: CustomIconAlignment.left,
                                      icon: AppStaticImages.communityRecent,
                                      height: AppSize.width(value: 36),
                                      width: AppSize.height(value: 110),
                                      fontSize: 12,
                                      iconSize: 15,
                                      title: "Popular",
                                      backgroundColor:
                                          controller.isFilterSelected(
                                            ForumFilter.popular,
                                          )
                                          ? AppColors.iconWarming
                                          : AppColors.white500,
                                      titleColor: AppColors.black,
                                      onTap: () => controller.selectFilter(
                                        ForumFilter.popular,
                                      ),
                                      borderColor: AppColors.grey100,
                                      borderRadius: 12,
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                        Gap(height: 03),
                      ],
                    ),
                  ),
                ),
              ),
              GetBuilder<CommunityScreenController>(
                builder: (controller) =>
                    _buildContent(controller, articleImages),
              ),
              GetBuilder<CommunityScreenController>(
                builder: (controller) => SliverToBoxAdapter(
                  child: controller.selectedTab == CommunityTab.article
                      ? Gap(height: 70)
                      : Gap(height: 120),
                ),
              ), // Extra space for fixed button
            ],
          ),
          // Fixed Create Post Button at bottom (only for Peer Forum)
          GetBuilder<CommunityScreenController>(
            builder: (controller) =>
                controller.selectedTab == CommunityTab.peerForum
                ? Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 20),
                        vertical: AppSize.height(value: 10),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: AppButton(
                          onTap: () {
                            Get.toNamed(AppRoute.creatingPost);
                          },
                          title: "Create Post",
                          backgroundColor: AppColors.primary500,
                          titleColor: AppColors.white,
                          height: AppSize.height(value: 40),
                          borderradius: 12,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    CommunityScreenController controller,
    List<String> articleImages,
  ) {
    if (controller.selectedTab == CommunityTab.article) {
      // Show articles when Article tab is selected
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 20),
              vertical: AppSize.height(value: 8),
            ),
            child: CourseCard(
              onTap: () {
                Get.toNamed(AppRoute.articleScreen);
              },
              margin: EdgeInsets.only(bottom: 08),
              cardType: CardType.article,
              title: "The Science Behind Mindfulness Meditation",
              instructor: "Dr Rizal Dy Ferrer",
              timeToread: "5 minutes to read",
              date: "12 Aug, 2024",
              imageUrl: articleImages[index % articleImages.length],
            ),
          );
        }, childCount: articleImages.length),
      );
    } else {
      // Show posts for Peer Forum with different content based on filter
      String postText;
      switch (controller.selectedFilter) {
        case ForumFilter.recent:
          postText = AppString.demoPost;
          break;
        case ForumFilter.highlight:
          postText = AppString.demoHighLightPost;
          break;
        case ForumFilter.popular:
          postText = AppString.demoPopularPost;
          break;
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
                vertical: AppSize.height(value: 8),
              ),
              child: SocialMediaPostCard(
                postText: postText,
                userName: "User ${index + 1}",
                userLocation: "Dhaka, Bangladesh",
                profileImage: AppStaticImages.postProfile,
                likesCount: 10 + index,
                commentsCount: 5 + index,
                onCommentTap: () {
                  showCommentsBottomSheet();
                },
              ),
            );
          },
          childCount: 10, // Show 10 posts
        ),
      );
    }
  }

  void showCommentsBottomSheet() {
    Get.bottomSheet(
      CommentsBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
