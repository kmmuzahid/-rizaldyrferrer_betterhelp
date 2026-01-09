import 'package:better_help/screen/community_sections/main_community/model/article_model.dart'
    as article_model;
import 'package:better_help/screen/community_sections/main_community/model/post_model.dart';
import 'package:better_help/service/repository/community_repository/community_repository.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CommunityTab { peerForum, article }

enum ForumFilter { recent, highlight, popular }

class CommunityScreenController extends GetxController {
  final _repository = CommunityRepository();

  // Selection states (non-reactive for GetBuilder)
  CommunityTab selectedTab = CommunityTab.peerForum;
  ForumFilter selectedFilter = ForumFilter.recent;

  // Add a flag to prevent multiple simultaneous updates
  bool _isUpdating = false;

  // Article related observables
  final RxBool isLoadingArticles = false.obs;
  final RxList<article_model.Datum> articles = <article_model.Datum>[].obs;
  final Rx<article_model.Meta?> articleMeta = Rx<article_model.Meta?>(null);
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreArticles = true.obs;

  // Post related observables
  final RxBool isLoadingPosts = false.obs;
  final RxList<Post> posts = <Post>[].obs;
  final Rx<Meta?> postMeta = Rx<Meta?>(null);
  final RxInt currentPostPage = 1.obs;
  final RxBool hasMorePosts = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure initial values are set
    selectedTab = CommunityTab.peerForum;
    selectedFilter = ForumFilter.recent;
    appLog(
      'Controller initialized - Tab: $selectedTab, Filter: $selectedFilter',
    );
    // Load articles when controller initializes
    fetchArticles();
    // Load posts when controller initializes
    fetchPosts();
  }

  // Method to select tab (Peer Forum or Article)
  void selectTab(CommunityTab tab) {
    // Prevent multiple simultaneous updates
    if (_isUpdating || selectedTab == tab) {
      appLog('Tab selection ignored - already updating or same tab');
      return;
    }

    _isUpdating = true;
    appLog('Selecting tab: $tab (from: $selectedTab)');
    selectedTab = tab;
    // Reset filter to recent when switching tabs
    selectedFilter = ForumFilter.recent;
    appLog('Tab selected: $selectedTab, Filter reset to: $selectedFilter');

    // Load articles when switching to article tab
    if (tab == CommunityTab.article && articles.isEmpty) {
      fetchArticles();
    }

    // Force immediate update for tab switching
    update();

    // Use post-frame callback to reset the updating flag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdating = false;
      appLog('Tab update completed, _isUpdating reset to false');
    });
  }

  // Method to select filter (Recent, Highlight, Popular)
  void selectFilter(ForumFilter filter) {
    // Prevent multiple simultaneous updates
    if (_isUpdating || selectedFilter == filter) {
      appLog('Filter selection ignored - already updating or same filter');
      return;
    }

    _isUpdating = true;
    appLog('Selecting filter: $filter (from: $selectedFilter)');
    selectedFilter = filter;
    appLog('Filter selected: $selectedFilter');

    // Fetch posts based on the selected filter
    fetchPosts();

    // Force immediate update for filter switching
    update();

    // Use post-frame callback to reset the updating flag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUpdating = false;
      appLog('Filter update completed, _isUpdating reset to false');
    });
  }

  // Helper methods to check current selections
  bool isTabSelected(CommunityTab tab) {
    bool result = selectedTab == tab;
    appLog('isTabSelected($tab): $result (current: $selectedTab)');
    return result;
  }

  bool isFilterSelected(ForumFilter filter) {
    bool result = selectedFilter == filter;
    appLog('isFilterSelected($filter): $result (current: $selectedFilter)');
    return result;
  }

  //! Fetch articles from API
  Future<void> fetchArticles({bool refresh = false}) async {
    if (isLoadingArticles.value) return;

    try {
      if (refresh) {
        currentPage.value = 1;
        articles.clear();
        hasMoreArticles.value = true;
      }

      isLoadingArticles.value = true;
      appLog('Fetching articles - Page: ${currentPage.value}');

      final result = await _repository.getAllArticles(
        page: currentPage.value,
        limit: 10,
      );

      if (result != null && result.data != null) {
        appLog('Articles fetched successfully: ${result.data!.length} items');

        if (refresh) {
          articles.value = result.data!;
        } else {
          articles.addAll(result.data!);
        }

        articleMeta.value = result.meta;

        // Check if there are more articles
        if (result.meta != null) {
          hasMoreArticles.value =
              currentPage.value < (result.meta!.totalPage ?? 0);
        }
      } else {
        appLog('Failed to fetch articles');
      }
    } catch (e) {
      appLog('Error fetching articles: $e');
    } finally {
      isLoadingArticles.value = false;
    }
  }

  //! Load more articles (pagination)
  Future<void> loadMoreArticles() async {
    if (!hasMoreArticles.value || isLoadingArticles.value) return;

    currentPage.value++;
    await fetchArticles();
  }

  //! Refresh articles
  Future<void> refreshArticles() async {
    await fetchArticles(refresh: true);
  }

  //! Fetch posts from API based on selected filter
  Future<void> fetchPosts({bool refresh = false}) async {
    if (isLoadingPosts.value) return;

    try {
      if (refresh) {
        currentPostPage.value = 1;
        posts.clear();
        hasMorePosts.value = true;
      }

      isLoadingPosts.value = true;
      appLog(
        'Fetching posts - Filter: $selectedFilter, Page: ${currentPostPage.value}',
      );

      PostModel? result;

      // Fetch posts based on selected filter
      switch (selectedFilter) {
        case ForumFilter.recent:
          result = await _repository.getRecentPosts(
            page: currentPostPage.value,
            limit: 10,
          );
          break;
        case ForumFilter.highlight:
          result = await _repository.getHighlightPosts(
            page: currentPostPage.value,
            limit: 10,
          );
          break;
        case ForumFilter.popular:
          result = await _repository.getPopularPosts(
            page: currentPostPage.value,
            limit: 10,
          );
          break;
      }

      if (result != null && result.data != null) {
        appLog('Posts fetched successfully: ${result.data!.length} items');

        if (refresh) {
          posts.value = result.data!;
        } else {
          posts.addAll(result.data!);
        }

        postMeta.value = result.meta;

        // Check if there are more posts
        if (result.meta != null) {
          hasMorePosts.value =
              currentPostPage.value < (result.meta!.totalPage ?? 0);
        }
      } else {
        appLog('Failed to fetch posts');
      }
    } catch (e) {
      appLog('Error fetching posts: $e');
    } finally {
      isLoadingPosts.value = false;
    }
  }

  //! Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (!hasMorePosts.value || isLoadingPosts.value) return;

    currentPostPage.value++;
    await fetchPosts();
  }

  //! Refresh posts
  Future<void> refreshPosts() async {
    await fetchPosts(refresh: true);
  }

  //! Like/Unlike a post
  Future<void> likePost(String postId, int index) async {
    appLog('Liking post with ID: $postId');

    try {
      // Optimistically update UI
      final post = posts[index];
      final isCurrentlyLiked = post.likes?.contains(postId) ?? false;
      
      // Update the post in the list
      posts[index] = Post(
        id: post.id,
        userId: post.userId,
        description: post.description,
        likes: post.likes,
        highlights: post.highlights,
        commentsCount: post.commentsCount,
        likesCount: isCurrentlyLiked 
            ? (post.likesCount ?? 0) - 1 
            : (post.likesCount ?? 0) + 1,
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      );
      posts.refresh();

      // Call API
      final success = await _repository.likePost(postId);

      if (!success) {
        // Revert on failure
        posts[index] = post;
        posts.refresh();
        appLog('Failed to like/unlike post');
      } else {
        appLog('Post liked/unliked successfully');
      }
    } catch (e) {
      appLog('Error liking post: $e');
    }
  }

  @override
  void onClose() {
    // Clean up resources when controller is disposed
    _isUpdating = false;
    appLog('Controller disposed');
    super.onClose();
  }
}
