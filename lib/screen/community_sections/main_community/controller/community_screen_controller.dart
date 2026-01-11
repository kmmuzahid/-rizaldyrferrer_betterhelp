import 'package:better_help/screen/community_sections/main_community/model/article_model.dart'
    as article_model;
import 'package:better_help/screen/community_sections/main_community/model/post_model.dart';
import 'package:better_help/service/repository/community_repository/community_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CommunityTab { peerForum, article }

enum ForumFilter { none, recent, highlight, popular }

class CommunityScreenController extends GetxController {
  final _repository = CommunityRepository();

  // Selection states (non-reactive for GetBuilder)
  CommunityTab selectedTab = CommunityTab.peerForum;
  ForumFilter selectedFilter = ForumFilter.none;

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
    selectedFilter = ForumFilter.none;
    appLog(
      'Controller initialized - Tab: $selectedTab, Filter: $selectedFilter',
    );
    // Load articles when controller initializes
    fetchArticles();
    // Load all posts when controller initializes (no filter)
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
    // Reset filter to none when switching tabs
    selectedFilter = ForumFilter.none;
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

    // Clear posts when changing filters
    posts.clear();
    currentPostPage.value = 1;

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
        // Don't clear posts immediately to preserve like states
        hasMorePosts.value = true;
      }

      isLoadingPosts.value = true;
      appLog(
        'Fetching posts - Filter: $selectedFilter, Page: ${currentPostPage.value}',
      );

      PostModel? result;

      // Fetch posts based on selected filter
      switch (selectedFilter) {
        case ForumFilter.none:
          result = await _repository.getAllPosts(
            page: currentPostPage.value,
            limit: 10,
          );
          break;
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

        // Get current user ID from storage
        final userData = await StorageService.instance.getUserData();
        final currentUserId = userData?['_id'] as String?;

        if (refresh) {
          // Update posts with correct like states based on likes array
          posts.value = result.data!.map((newPost) {
            // Check if current user ID is in the likes array
            final isLikedByCurrentUser =
                currentUserId != null &&
                newPost.likes != null &&
                newPost.likes!.contains(currentUserId);

            return Post(
              id: newPost.id,
              userId: newPost.userId,
              description: newPost.description,
              likes: newPost.likes,
              highlights: newPost.highlights,
              commentsCount: newPost.commentsCount,
              likesCount: newPost.likesCount,
              isDeleted: newPost.isDeleted,
              createdAt: newPost.createdAt,
              updatedAt: newPost.updatedAt,
              isLiked: isLikedByCurrentUser,
            );
          }).toList();
        } else {
          // For pagination, also check likes array
          final newPosts = result.data!.map((newPost) {
            final isLikedByCurrentUser =
                currentUserId != null &&
                newPost.likes != null &&
                newPost.likes!.contains(currentUserId);

            return Post(
              id: newPost.id,
              userId: newPost.userId,
              description: newPost.description,
              likes: newPost.likes,
              highlights: newPost.highlights,
              commentsCount: newPost.commentsCount,
              likesCount: newPost.likesCount,
              isDeleted: newPost.isDeleted,
              createdAt: newPost.createdAt,
              updatedAt: newPost.updatedAt,
              isLiked: isLikedByCurrentUser,
            );
          }).toList();
          posts.addAll(newPosts);
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
    appLog('Liking post with ID: $postId at index: $index');

    try {
      // Get current user ID
      final userData = await StorageService.instance.getUserData();
      final currentUserId = userData?['_id'] as String?;

      if (currentUserId == null) {
        appLog('Cannot like post: User ID not found');
        return;
      }

      // Get the current post
      final post = posts[index];
      final currentLikeState = post.isLiked ?? false;

      // Update likes array
      List<dynamic> updatedLikes = List.from(post.likes ?? []);
      if (currentLikeState) {
        // Remove user ID from likes array
        updatedLikes.remove(currentUserId);
      } else {
        // Add user ID to likes array
        updatedLikes.add(currentUserId);
      }

      // Optimistically update UI immediately
      posts[index] = Post(
        id: post.id,
        userId: post.userId,
        description: post.description,
        likes: updatedLikes,
        highlights: post.highlights,
        commentsCount: post.commentsCount,
        likesCount: currentLikeState
            ? (post.likesCount ?? 1) - 1
            : (post.likesCount ?? 0) + 1,
        isDeleted: post.isDeleted,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        isLiked: !currentLikeState, // Toggle like state
      );
      posts.refresh();

      // Call API in background
      final success = await _repository.likePost(postId);

      if (!success) {
        // Revert on failure
        appLog('Failed to like/unlike post - reverting changes');
        posts[index] = post;
        posts.refresh();
      } else {
        appLog('Post liked/unliked successfully');
      }
    } catch (e) {
      appLog('Error liking post: $e');
      // Revert on error
      if (index < posts.length) {
        final post = posts[index];
        posts[index] = post;
        posts.refresh();
      }
    }
  }

  @override
  void onClose() {
    // Clean up resources when controller is disposed
    _isUpdating = false;
    appLog('Controller disposed');
    super.onClose();
  }

  //! Toggle save/unsave article
  Future<void> toggleSaveArticle(String articleId, int index) async {
    appLog('Toggling save for article with ID: $articleId at index: $index');

    try {
      // Get the current article
      final article = articles[index];
      final currentSaveState = article.isFavorite ?? false;

      // Optimistically update UI immediately
      articles[index] = article_model.Datum(
        id: article.id,
        title: article.title,
        description: article.description,
        image: article.image,
        publicationDate: article.publicationDate,
        sourseName: article.sourseName,
        readTime: article.readTime,
        isDeleted: article.isDeleted,
        createdAt: article.createdAt,
        updatedAt: article.updatedAt,
        isFavorite: !currentSaveState,
      );
      articles.refresh();

      // Call API in background
      final success = await _repository.toggleSaveArticle(articleId);

      if (!success) {
        // Revert on failure
        appLog('Failed to toggle save state - reverting changes');
        articles[index] = article;
        articles.refresh();
      } else {
        appLog('Article save state toggled successfully');
      }
    } catch (e) {
      appLog('Error toggling article save state: $e');
      // Revert on error
      if (index < articles.length) {
        final article = articles[index];
        articles[index] = article;
        articles.refresh();
      }
    }
  }
}
