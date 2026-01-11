import 'package:better_help/screen/community_sections/main_community/model/single_post_model.dart';
import 'package:better_help/service/repository/community_repository/community_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SinglePostController extends GetxController {
  final _repository = CommunityRepository();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  // Observable states
  final RxBool isLoadingPost = false.obs;
  final RxBool isSubmittingComment = false.obs;
  final Rx<SinglePostModel?> postData = Rx<SinglePostModel?>(null);
  final RxString currentUserId = ''.obs;

  // For reply functionality
  final RxString replyingToCommentId = ''.obs;
  final RxString replyingToUserName = ''.obs;
  final RxBool isReplyMode = false.obs;

  String postId = '';

  @override
  void onInit() {
    super.onInit();
    // Get post ID from arguments
    postId = Get.arguments as String? ?? '';
    if (postId.isNotEmpty) {
      fetchPostDetails();
    }
    _loadCurrentUserId();
  }

  //! Load current user ID
  Future<void> _loadCurrentUserId() async {
    final userData = await StorageService.instance.getUserData();
    currentUserId.value = userData?['_id'] as String? ?? '';
  }

  //! Fetch post details with comments
  Future<void> fetchPostDetails({bool refresh = false}) async {
    if (isLoadingPost.value && !refresh) return;

    try {
      isLoadingPost.value = true;
      appLog('Fetching post details for ID: $postId');

      final response = await _repository.getSinglePost(postId);

      if (response != null && response['success'] == true) {
        postData.value = SinglePostModel.fromJson(response);
        appLog('Post details fetched successfully');
      } else {
        appLog('Failed to fetch post details');
      }
    } catch (e) {
      appLog('Error fetching post details: $e');
    } finally {
      isLoadingPost.value = false;
    }
  }

  //! Submit a comment
  Future<void> submitComment() async {
    if (commentController.text.trim().isEmpty) {
      appLog('Comment text is empty');
      return;
    }

    try {
      isSubmittingComment.value = true;
      appLog('Submitting comment: ${commentController.text}');

      final response = await _repository.createComment(
        postId: postId,
        message: commentController.text.trim(),
      );

      if (response != null && response['success'] == true) {
        appLog('Comment submitted successfully');
        commentController.clear();
        // Refresh post to show new comment
        await fetchPostDetails(refresh: true);
      } else {
        appLog('Failed to submit comment');
      }
    } catch (e) {
      appLog('Error submitting comment: $e');
    } finally {
      isSubmittingComment.value = false;
    }
  }

  //! Submit a reply to a comment
  Future<void> submitReply() async {
    if (replyController.text.trim().isEmpty ||
        replyingToCommentId.value.isEmpty) {
      appLog('Reply text or parent comment ID is empty');
      return;
    }

    try {
      isSubmittingComment.value = true;
      appLog('Submitting reply to comment: ${replyingToCommentId.value}');

      final response = await _repository.createReply(
        postId: postId,
        message: replyController.text.trim(),
        parentId: replyingToCommentId.value,
      );

      if (response != null && response['success'] == true) {
        appLog('Reply submitted successfully');
        replyController.clear();
        cancelReply();
        // Refresh post to show new reply
        await fetchPostDetails(refresh: true);
      } else {
        appLog('Failed to submit reply');
      }
    } catch (e) {
      appLog('Error submitting reply: $e');
    } finally {
      isSubmittingComment.value = false;
    }
  }

  //! Set reply mode
  void setReplyMode(String commentId, String userName) {
    replyingToCommentId.value = commentId;
    replyingToUserName.value = userName;
    isReplyMode.value = true;
    appLog('Reply mode activated for comment: $commentId');
  }

  //! Cancel reply mode
  void cancelReply() {
    replyingToCommentId.value = '';
    replyingToUserName.value = '';
    isReplyMode.value = false;
    replyController.clear();
    appLog('Reply mode cancelled');
  }

  //! Refresh post
  Future<void> refreshPost() async {
    await fetchPostDetails(refresh: true);
  }

  @override
  void onClose() {
    commentController.dispose();
    replyController.dispose();
    super.onClose();
  }
}
