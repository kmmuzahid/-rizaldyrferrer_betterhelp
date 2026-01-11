import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/community_sections/main_community/controller/community_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_button/app_button_with_icon.dart';
import 'package:better_help/widget/app_comments_widget/app_comments_widget.dart';
import 'package:better_help/widget/app_course_card/app_course_card.dart';
import 'package:better_help/widget/app_post_card/app_post_card.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
                      ? AppSize.height(value: 80)
                      : AppSize.height(value: 120),
                  collapsedHeight:
                      controller.selectedTab == CommunityTab.article
                      ? AppSize.height(value: 80)
                      : AppSize.height(value: 120),
                  toolbarHeight: controller.selectedTab == CommunityTab.article
                      ? AppSize.height(value: 80)
                      : AppSize.height(value: 120),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      width: AppSize.height(value: 100),
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
                                      width: AppSize.height(value: 125),
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
                                      width: AppSize.height(value: 100),
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
              //! Fixed: Move GetBuilder inside the sliver content
              GetBuilder<CommunityScreenController>(
                builder: (controller) {
                  appLog(
                    'Building content for tab: ${controller.selectedTab}',
                  ); // Debug log

                  if (controller.selectedTab == CommunityTab.article) {
                    appLog('Rendering articles list'); // Debug log
                    // Show articles when Article tab is selected
                    return Obx(() {
                      if (controller.isLoadingArticles.value &&
                          controller.articles.isEmpty) {
                        // Show loading for initial load
                        return SliverFillRemaining(
                          child: Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              color: AppColors.primary500,
                              size: 50,
                            ),
                          ),
                        );
                      }

                      if (controller.articles.isEmpty) {
                        // Show empty state
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 64,
                                  color: AppColors.grey100,
                                ),
                                Gap(height: 16),
                                AppText(
                                  text: "No articles available",
                                  fontSize: 16,
                                  color: AppColors.grey100,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        key: ValueKey('article_list'),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Show loading indicator at the end
                            if (index == controller.articles.length) {
                              if (controller.hasMoreArticles.value) {
                                // Trigger load more
                                Future.microtask(
                                  () => controller.loadMoreArticles(),
                                );
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.height(value: 20),
                                  ),
                                  child: Center(
                                    child:
                                        LoadingAnimationWidget.staggeredDotsWave(
                                          color: AppColors.primary500,
                                          size: 40,
                                        ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            }

                            final article = controller.articles[index];

                            // Build full image URL if needed
                            String imageUrl = article.image ?? '';
                            if (imageUrl.isNotEmpty &&
                                !imageUrl.startsWith('http')) {
                              // If image is a relative path, prepend the base domain
                              imageUrl = '${AppApiurl.liveDomain}$imageUrl';
                            }

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.width(value: 20),
                                vertical: AppSize.height(value: 8),
                              ),
                              child: CourseCard(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoute.articleScreen,
                                    arguments: {'articleId': article.id},
                                  );
                                },
                                margin: EdgeInsets.only(bottom: 08),
                                height: AppSize.height(value: 245),
                                cardType: CardType.article,
                                title: article.title ?? "Untitled Article",
                                instructor:
                                    article.sourseName ?? "Unknown Author",
                                timeToread:
                                    article.readTime ?? "5 minutes to read",
                                date: article.publicationDate != null
                                    ? "${article.publicationDate!.day} ${_getMonthName(article.publicationDate!.month)}, ${article.publicationDate!.year}"
                                    : "Date not available",
                                imageUrl: imageUrl.isNotEmpty
                                    ? imageUrl
                                    : AppStaticImages.habits01,
                              ),
                            );
                          },
                          childCount:
                              controller.articles.length +
                              (controller.hasMoreArticles.value ? 1 : 0),
                        ),
                      );
                    });
                  } else {
                    appLog(
                      'Rendering posts list for filter: ${controller.selectedFilter}',
                    ); // Debug log
                    // Show posts for Peer Forum with real data from API
                    return Obx(() {
                      if (controller.isLoadingPosts.value &&
                          controller.posts.isEmpty) {
                        // Show loading for initial load
                        return SliverFillRemaining(
                          child: Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              color: AppColors.primary500,
                              size: 50,
                            ),
                          ),
                        );
                      }

                      if (controller.posts.isEmpty) {
                        // Show empty state
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.forum_outlined,
                                  size: 64,
                                  color: AppColors.grey100,
                                ),
                                Gap(height: 16),
                                AppText(
                                  text: "No posts available",
                                  fontSize: 16,
                                  color: AppColors.grey100,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        key: ValueKey(
                          'forum_list_${controller.selectedFilter}',
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Show loading indicator at the end
                            if (index == controller.posts.length) {
                              if (controller.hasMorePosts.value) {
                                // Trigger load more
                                Future.microtask(
                                  () => controller.loadMorePosts(),
                                );
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.height(value: 20),
                                  ),
                                  child: Center(
                                    child:
                                        LoadingAnimationWidget.staggeredDotsWave(
                                          color: AppColors.primary500,
                                          size: 40,
                                        ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            }

                            final post = controller.posts[index];

                            // Build profile image URL if needed
                            String profileImage = post.userId?.profile ?? '';
                            if (profileImage.isNotEmpty &&
                                !profileImage.startsWith('http')) {
                              profileImage =
                                  '${AppApiurl.imageUrl}$profileImage';
                            }

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.width(value: 20),
                                vertical: AppSize.height(value: 8),
                              ),
                              child: SocialMediaPostCard(
                                postText: post.description ?? "No description",
                                userName:
                                    post.userId?.fullName ?? "Unknown User",
                                userLocation:
                                    post.userId?.address ?? "Unknown Location",
                                profileImage: profileImage.isNotEmpty
                                    ? profileImage
                                    : AppStaticImages.postProfile,
                                likesCount: post.likesCount ?? 0,
                                commentsCount: post.commentsCount ?? 0,
                                isLiked: post.isLiked ?? false,
                                onLikeTap: () {
                                  if (post.id != null) {
                                    controller.likePost(post.id!, index);
                                  }
                                },
                                onCommentTap: () {
                                  // Navigate to comments bottom sheet with post ID
                                  if (post.id != null) {
                                    Get.bottomSheet(
                                      CommentsBottomSheet(postId: post.id),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          childCount:
                              controller.posts.length +
                              (controller.hasMorePosts.value ? 1 : 0),
                        ),
                      );
                    });
                  }
                },
              ),
              GetBuilder<CommunityScreenController>(
                builder: (controller) => SliverToBoxAdapter(
                  child: controller.selectedTab == CommunityTab.article
                      ? Gap(height: 80)
                      : Gap(height: 130),
                ),
              ), //! Extra space for fixed button
            ],
          ),
          //! Fixed Create Post Button at bottom (only for Peer Forum)
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
                          fontSize: AppSize.width(value: 12),
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

  void showCommentsBottomSheet() {
    Get.bottomSheet(
      CommentsBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
