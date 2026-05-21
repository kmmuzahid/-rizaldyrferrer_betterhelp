import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/community_sections/main_community/model/article_model.dart';
import 'package:better_help/screen/community_sections/main_community/model/post_model.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';

class CommunityRepository {
  //! Get all articles with pagination
  Future<ArticleModel?> getAllArticles({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching all articles...');
    appLog('CommunityRepository: Page - $page, Limit - $limit');

    final response = await DioService.instance.request<ArticleModel>(
      input: RequestInput(
        endpoint: '${ApiEndPoints.getAllArticle}?page=$page&limit=$limit',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => ArticleModel.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('CommunityRepository: Articles fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch articles');
      return null;
    }
  }

  //! Get single article by ID
  Future<Datum?> getSingleArticle(String id) async {
    appLog('CommunityRepository: Fetching article with ID - $id');

    final response = await DioService.instance.request<Datum>(
      input: RequestInput(
        endpoint: ApiEndPoints.getSingleArticle(id),
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => Datum.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('CommunityRepository: Article fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch article');
      return null;
    }
  }

  //! Create a post
  Future<ResponseState<dynamic>?> createApost(dynamic description) async {
    appLog('CommunityRepository: Creating a post...');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.createPost,
        method: RequestMethod.POST,
        jsonBody: description is Map<String, dynamic> ? description : null,
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Post created successfully');
      return response;
    } else {
      appLog('CommunityRepository: Failed to create post');
      return null;
    }
  }

  //! Get all posts with pagination
  Future<PostModel?> getAllPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching all posts...');
    appLog('CommunityRepository: Page - $page, Limit - $limit');

    final response = await DioService.instance.request<PostModel>(
      input: RequestInput(
        endpoint: '${ApiEndPoints.getAllPost}?page=$page&limit=$limit',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => PostModel.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('CommunityRepository: Posts fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch posts');
      return null;
    }
  }

  //! Get highlight posts
  Future<PostModel?> getHighlightPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching highlight posts...');

    final response = await DioService.instance.request<PostModel>(
      input: RequestInput(
        endpoint: '${ApiEndPoints.getHighlightPost}&page=$page&limit=$limit',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => PostModel.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('CommunityRepository: Highlight posts fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch highlight posts');
      return null;
    }
  }

  //! Get recent posts
  Future<PostModel?> getRecentPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching recent posts...');

    final response = await DioService.instance.request<PostModel>(
      input: RequestInput(
        endpoint: '${ApiEndPoints.getRecentPost}&page=$page&limit=$limit',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => PostModel.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('CommunityRepository: Recent posts fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch recent posts');
      return null;
    }
  }

  //! Get popular posts
  Future<PostModel?> getPopularPosts({int page = 1, int limit = 10}) async {
    appLog('CommunityRepository: Fetching popular posts...');

    final response = await DioService.instance.request<PostModel>(
      input: RequestInput(
        endpoint: '${ApiEndPoints.getPopularPost}&page=$page&limit=$limit',
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => PostModel.fromJson(data),
    );

    if (response.isSuccess && response.data != null) {
      appLog('CommunityRepository: Popular posts fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch popular posts');
      return null;
    }
  }

  //! Like/Unlike a post
  Future<bool> likePost(String postId) async {
    appLog('CommunityRepository: Liking post with ID - $postId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.getPostLike(postId),
        method: RequestMethod.POST,
        jsonBody: {},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Post liked/unliked successfully');
      return true;
    } else {
      appLog('CommunityRepository: Failed to like/unlike post');
      return false;
    }
  }

  //! Get single post with comments
  Future<dynamic> getSinglePost(String postId) async {
    appLog('CommunityRepository: Fetching post with ID - $postId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.getSinglePost(postId),
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Post fetched successfully');
      return response.data;
    } else {
      appLog('CommunityRepository: Failed to fetch post');
      return null;
    }
  }

  //! Create a comment on a post
  Future<ResponseState<dynamic>?> createComment({
    required String postId,
    required String message,
  }) async {
    appLog('CommunityRepository: Creating comment on post - $postId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.createComment,
        method: RequestMethod.POST,
        jsonBody: {'postId': postId, 'message': message},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Comment created successfully');
      return response;
    } else {
      appLog('CommunityRepository: Failed to create comment');
      return null;
    }
  }

  //! Create a reply to a comment
  Future<ResponseState<dynamic>?> createReply({
    required String postId,
    required String message,
    required String parentId,
  }) async {
    appLog('CommunityRepository: Creating reply to comment - $parentId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.createCommentReply,
        method: RequestMethod.POST,
        jsonBody: {'postId': postId, 'message': message, 'parentId': parentId},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Reply created successfully');
      return response;
    } else {
      appLog('CommunityRepository: Failed to create reply');
      return null;
    }
  }

  //! React on a comment
  Future<bool> reactOnComment(String commentId) async {
    appLog('CommunityRepository: Reacting on comment - $commentId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.reactOnComment,
        method: RequestMethod.POST,
        jsonBody: {'commentId': commentId},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Comment reaction successful');
      return true;
    } else {
      appLog('CommunityRepository: Failed to react on comment');
      return false;
    }
  }

  //! React on a comment reply
  Future<bool> reactOnCommentReply({
    required String commentId,
    required String replyId,
  }) async {
    appLog('CommunityRepository: Reacting on reply - $replyId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.reactOnCommentReply,
        method: RequestMethod.POST,
        jsonBody: {'commentId': commentId, 'replyId': replyId},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('CommunityRepository: Reply reaction successful');
      return true;
    } else {
      appLog('CommunityRepository: Failed to react on reply');
      return false;
    }
  }

  //! Toggle save/unsave article
  Future<bool> toggleSaveArticle(String articleId) async {
    appLog('CommunityRepository: Toggling save for article - $articleId');

    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.toggleSaveArticle(articleId),
        method: RequestMethod.POST,
        jsonBody: {'articleId': articleId},
      ),
      responseBuilder: (data) => data,
    );

    appLog('CommunityRepository: API response received: $response');

    if (response.isSuccess) {
      appLog('CommunityRepository: Article save toggled successfully');
      return true;
    } else {
      appLog(
        'CommunityRepository: Failed to toggle article save - Response: $response',
      );
      return false;
    }
  }
}
