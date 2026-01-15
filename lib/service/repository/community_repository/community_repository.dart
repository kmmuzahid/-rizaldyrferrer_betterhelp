import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/community_sections/main_community/model/article_model.dart';
import 'package:better_help/screen/community_sections/main_community/model/post_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_log/error_log.dart';

class CommunityRepository {
  final _apiServices = ApiServices.instance;

  //! Get all articles with pagination
  Future<ArticleModel?> getAllArticles({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching all articles...');
    appLog('CommunityRepository: Page - $page, Limit - $limit');

    try {
      final response = await _apiServices.apiGetServices(
        '${AppApiurl.getAllArticle}?page=$page&limit=$limit',
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Articles fetched successfully');
        return ArticleModel.fromJson(response);
      } else {
        appLog('CommunityRepository: Failed to fetch articles');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during fetching articles', e);
      return null;
    }
  }

  //! Get single article by ID
  Future<Datum?> getSingleArticle(String id) async {
    appLog('CommunityRepository: Fetching article with ID - $id');

    try {
      final response = await _apiServices.apiGetServices(
        AppApiurl.getSingleArticle(id),
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Article fetched successfully');
        return Datum.fromJson(response['data']);
      } else {
        appLog('CommunityRepository: Failed to fetch article');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during fetching article', e);
      return null;
    }
  }

  //! Create a post
  Future<dynamic> createApost(dynamic description) async {
    appLog('CommunityRepository: Creating a post...');
    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.createPost,
        body: description,
      );
      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Post created successfully');
        return response;
      } else {
        appLog('CommunityRepository: Failed to create post');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during creating post', e);
      return null;
    }
  }

  //! Get all posts with pagination
  Future<PostModel?> getAllPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching all posts...');
    appLog('CommunityRepository: Page - $page, Limit - $limit');

    try {
      final response = await _apiServices.apiGetServices(
        '${AppApiurl.getAllPost}?page=$page&limit=$limit',
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Posts fetched successfully');
        return PostModel.fromJson(response);
      } else {
        appLog('CommunityRepository: Failed to fetch posts');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during fetching posts', e);
      return null;
    }
  }

  //! Get highlight posts
  Future<PostModel?> getHighlightPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching highlight posts...');

    try {
      final response = await _apiServices.apiGetServices(
        '${AppApiurl.getHighlightPost}&page=$page&limit=$limit',
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Highlight posts fetched successfully');
        return PostModel.fromJson(response);
      } else {
        appLog('CommunityRepository: Failed to fetch highlight posts');
        return null;
      }
    } catch (e) {
      errorLog(
        'CommunityRepository: Exception during fetching highlight posts',
        e,
      );
      return null;
    }
  }

  //! Get recent posts
  Future<PostModel?> getRecentPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching recent posts...');

    try {
      final response = await _apiServices.apiGetServices(
        '${AppApiurl.getRecentPost}&page=$page&limit=$limit',
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Recent posts fetched successfully');
        return PostModel.fromJson(response);
      } else {
        appLog('CommunityRepository: Failed to fetch recent posts');
        return null;
      }
    } catch (e) {
      errorLog(
        'CommunityRepository: Exception during fetching recent posts',
        e,
      );
      return null;
    }
  }

  //! Get popular posts
  Future<PostModel?> getPopularPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching popular posts...');

    try {
      final response = await _apiServices.apiGetServices(
        '${AppApiurl.getPopularPost}&page=$page&limit=$limit',
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Popular posts fetched successfully');
        return PostModel.fromJson(response);
      } else {
        appLog('CommunityRepository: Failed to fetch popular posts');
        return null;
      }
    } catch (e) {
      errorLog(
        'CommunityRepository: Exception during fetching popular posts',
        e,
      );
      return null;
    }
  }

  //! Like/Unlike a post
  Future<bool> likePost(String postId) async {
    appLog('CommunityRepository: Liking post with ID - $postId');

    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.getPostLike(postId),
        body: {},
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Post liked/unliked successfully');
        return true;
      } else {
        appLog('CommunityRepository: Failed to like/unlike post');
        return false;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during liking post', e);
      return false;
    }
  }

  //! Get single post with comments
  Future<dynamic> getSinglePost(String postId) async {
    appLog('CommunityRepository: Fetching post with ID - $postId');

    try {
      final response = await _apiServices.apiGetServices(
        AppApiurl.getSinglePost(postId),
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Post fetched successfully');
        return response;
      } else {
        appLog('CommunityRepository: Failed to fetch post');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during fetching post', e);
      return null;
    }
  }

  //! Create a comment on a post
  Future<dynamic> createComment({
    required String postId,
    required String message,
  }) async {
    appLog('CommunityRepository: Creating comment on post - $postId');

    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.createComment,
        body: {'postId': postId, 'message': message},
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Comment created successfully');
        return response;
      } else {
        appLog('CommunityRepository: Failed to create comment');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during creating comment', e);
      return null;
    }
  }

  //! Create a reply to a comment
  Future<dynamic> createReply({
    required String postId,
    required String message,
    required String parentId,
  }) async {
    appLog('CommunityRepository: Creating reply to comment - $parentId');

    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.createCommentReply,
        body: {'postId': postId, 'message': message, 'parentId': parentId},
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Reply created successfully');
        return response;
      } else {
        appLog('CommunityRepository: Failed to create reply');
        return null;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during creating reply', e);
      return null;
    }
  }

  //! React on a comment
  Future<bool> reactOnComment(String commentId) async {
    appLog('CommunityRepository: Reacting on comment - $commentId');

    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.reactOnComment,
        body: {'commentId': commentId},
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Comment reaction successful');
        return true;
      } else {
        appLog('CommunityRepository: Failed to react on comment');
        return false;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during reacting on comment', e);
      return false;
    }
  }

  //! React on a comment reply
  Future<bool> reactOnCommentReply({
    required String commentId,
    required String replyId,
  }) async {
    appLog('CommunityRepository: Reacting on reply - $replyId');

    try {
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.reactOnCommentReply,
        body: {'commentId': commentId, 'replyId': replyId},
      );

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Reply reaction successful');
        return true;
      } else {
        appLog('CommunityRepository: Failed to react on reply');
        return false;
      }
    } catch (e) {
      errorLog('CommunityRepository: Exception during reacting on reply', e);
      return false;
    }
  }

  //! Toggle save/unsave article
  Future<bool> toggleSaveArticle(String articleId) async {
    appLog('CommunityRepository: Toggling save for article - $articleId');

    try {
      appLog(
        'CommunityRepository: Calling API with body: {"articleId": "$articleId"}',
      );

      final response = await _apiServices.apiPostServices(
        url: AppApiurl.toggleSaveArticle(articleId),
        body: {'articleId': articleId},
        statusCodeStart: 200,
        statusCodeEnd: 201,
      );

      appLog('CommunityRepository: API response received: $response');

      if (response != null && response['success'] == true) {
        appLog('CommunityRepository: Article save toggled successfully');
        return true;
      } else {
        appLog(
          'CommunityRepository: Failed to toggle article save - Response: $response',
        );
        return false;
      }
    } catch (e) {
      errorLog(
        'CommunityRepository: Exception during toggling article save',
        e,
      );
      return false;
    }
  }
}
