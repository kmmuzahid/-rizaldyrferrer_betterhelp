import 'package:better_help/screen/community_sections/main_community/model/single_post_model.dart'
    as post_model;
import 'package:better_help/service/repository/community_repository/community_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Comment Model (keeping for backward compatibility with mock data)
class Comment {
  final int id;
  final String user;
  final String avatar;
  final String text;
  final int likes;
  final List<Comment> replies;
  bool isLiked;
  bool showReplies;

  Comment({
    required this.id,
    required this.user,
    required this.avatar,
    required this.text,
    required this.likes,
    required this.replies,
    this.isLiked = false,
    this.showReplies = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      user: json['user'],
      avatar: json['avatar'],
      text: json['text'],
      likes: json['likes'],
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((reply) => Comment.fromJson(reply))
                .toList()
          : [],
    );
  }
}

// Comments Controller
class CommentsController extends GetxController {
  final _repository = CommunityRepository();

  RxList<Comment> comments = <Comment>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  Rx<Comment?> replyingTo = Rx<Comment?>(null);

  // Real API data
  Rx<post_model.SinglePostModel?> postData = Rx<post_model.SinglePostModel?>(
    null,
  );
  String postId = '';

  // For reply tracking with real API
  RxString replyingToCommentId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get post ID from arguments if provided
    if (Get.arguments != null && Get.arguments is String) {
      postId = Get.arguments as String;
      loadRealComments();
    } else {
      loadComments(); // Fallback to mock data
    }
  }

  void loadComments() {
    // Your mock data
    final mockData = {
      "comments": [
        {
          "id": 1,
          "user": "Rundownby",
          "avatar": "https://i.pravatar.cc/150?img=3",
          "text":
              "This is incredible. I have always looked forward to your work.",
          "likes": 1200,
          "replies": [
            {
              "id": 11,
              "user": "Dadaboyy",
              "avatar": "https://i.pravatar.cc/150?img=4",
              "text": "Totally agree! This is on another level.",
              "likes": 450,
              "replies": [
                {
                  "id": 111,
                  "user": "marvel_fanatic",
                  "avatar": "https://i.pravatar.cc/150?img=5",
                  "text": "Exactly, I've been waiting for this too!",
                  "likes": 120,
                  "replies": [
                    {
                      "id": 1111,
                      "user": "tech_guru",
                      "avatar": "https://i.pravatar.cc/150?img=6",
                      "text": "Haha same here, this blew my mind 🤯",
                      "likes": 75,
                      "replies": [],
                    },
                  ],
                },
              ],
            },
            {
              "id": 12,
              "user": "creative_guy",
              "avatar": "https://i.pravatar.cc/150?img=7",
              "text": "Man, I wish I had your skills 🔥",
              "likes": 210,
              "replies": [],
            },
          ],
        },
        {
          "id": 2,
          "user": "Dadaboyy",
          "avatar": "https://i.pravatar.cc/150?img=8",
          "text": "Seems like I'm still a beginner, cause what!! This is huge.",
          "likes": 1800,
          "replies": [
            {
              "id": 21,
              "user": "newbie123",
              "avatar": "https://i.pravatar.cc/150?img=9",
              "text": "Same here bro, this is crazy inspiring!",
              "likes": 90,
              "replies": [
                {
                  "id": 211,
                  "user": "old_timer",
                  "avatar": "https://i.pravatar.cc/150?img=10",
                  "text": "Trust me, we all start somewhere! Keep going 💪",
                  "likes": 60,
                  "replies": [
                    {
                      "id": 2111,
                      "user": "mentor_guy",
                      "avatar": "https://i.pravatar.cc/150?img=11",
                      "text": "That's the spirit! Everyone grows step by step.",
                      "likes": 35,
                      "replies": [],
                    },
                  ],
                },
              ],
            },
          ],
        },
        {
          "id": 3,
          "user": "marvel_fanatic",
          "avatar": "https://i.pravatar.cc/150?img=12",
          "text": "You've got to commission this man.",
          "likes": 1800,
          "replies": [
            {
              "id": 31,
              "user": "comic_lover",
              "avatar": "https://i.pravatar.cc/150?img=13",
              "text": "Marvel should really hire him officially.",
              "likes": 500,
              "replies": [
                {
                  "id": 311,
                  "user": "studio_artist",
                  "avatar": "https://i.pravatar.cc/150?img=14",
                  "text": "That would be a dream come true!",
                  "likes": 150,
                  "replies": [
                    {
                      "id": 3111,
                      "user": "fanboy",
                      "avatar": "https://i.pravatar.cc/150?img=15",
                      "text": "I'd love to see his work in actual comics 😍",
                      "likes": 95,
                      "replies": [],
                    },
                  ],
                },
              ],
            },
          ],
        },
      ],
    };

    comments.value = (mockData['comments'] as List)
        .map((comment) => Comment.fromJson(comment))
        .toList();
  }

  //! Load real comments from API
  Future<void> loadRealComments({bool refresh = false}) async {
    if (isLoading.value && !refresh) return;
    if (postId.isEmpty) return;

    try {
      isLoading.value = true;
      appLog('Loading comments for post: $postId');

      final response = await _repository.getSinglePost(postId);

      if (response != null && response['success'] == true) {
        postData.value = post_model.SinglePostModel.fromJson(response);

        // Get current user ID to set isLiked state
        final userData = await StorageService.instance.getUserData();
        final currentUserId = userData?['_id'] as String?;

        if (currentUserId != null && postData.value?.data?.comments != null) {
          // Update isLiked for all comments and replies
          for (var comment in postData.value!.data!.comments!) {
            _updateCommentLikeState(comment, currentUserId);
          }
        }

        appLog('Comments loaded successfully');
      } else {
        appLog('Failed to load comments');
      }
    } catch (e) {
      appLog('Error loading comments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //! Helper method to update like state for comments and replies
  void _updateCommentLikeState(post_model.Comment comment, String userId) {
    // Check if user liked this comment
    comment.isLiked = comment.likes?.contains(userId) ?? false;

    // Update like state for all replies recursively
    if (comment.replies != null) {
      for (var reply in comment.replies!) {
        _updateReplyLikeState(reply, userId);
      }
    }
  }

  //! Helper method to update like state for replies recursively
  void _updateReplyLikeState(post_model.Reply reply, String userId) {
    // Check if user liked this reply
    reply.isLiked = reply.likes?.contains(userId) ?? false;

    // Update like state for nested replies
    if (reply.replies != null) {
      for (var nestedReply in reply.replies!) {
        _updateReplyLikeState(nestedReply, userId);
      }
    }
  }

  //! Add a comment via API
  Future<void> addRealComment(String text) async {
    if (text.trim().isEmpty || postId.isEmpty) return;

    try {
      isSubmitting.value = true;
      appLog('Submitting comment: $text');

      final response = await _repository.createComment(
        postId: postId,
        message: text.trim(),
      );

      if (response != null && response['success'] == true) {
        appLog('Comment submitted successfully');
        commentController.clear();
        // Refresh comments
        await loadRealComments(refresh: true);
      } else {
        appLog('Failed to submit comment');
      }
    } catch (e) {
      appLog('Error submitting comment: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  //! Add a reply via API
  Future<void> addRealReply(String text, String parentId) async {
    if (text.trim().isEmpty || postId.isEmpty || parentId.isEmpty) return;

    try {
      isSubmitting.value = true;
      appLog('Submitting reply to: $parentId');

      final response = await _repository.createReply(
        postId: postId,
        message: text.trim(),
        parentId: parentId,
      );

      if (response != null && response['success'] == true) {
        appLog('Reply submitted successfully');
        replyController.clear();
        replyingToCommentId.value = '';
        replyingTo.value = null;
        // Refresh comments
        await loadRealComments(refresh: true);
      } else {
        appLog('Failed to submit reply');
      }
    } catch (e) {
      appLog('Error submitting reply: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  //! React on a comment
  Future<void> reactOnComment(post_model.Comment comment) async {
    if (comment.id == null) return;

    try {
      appLog('Reacting on comment: ${comment.id}');

      // Get current user ID
      final userData = await StorageService.instance.getUserData();
      final currentUserId = userData?['_id'] as String?;

      if (currentUserId == null) {
        appLog('Cannot react: User ID not found');
        return;
      }

      // Optimistically update UI
      final currentLikeState = comment.isLiked ?? false;
      comment.isLiked = !currentLikeState;

      // Update likes array
      List<dynamic> updatedLikes = List.from(comment.likes ?? []);
      if (currentLikeState) {
        updatedLikes.remove(currentUserId);
      } else {
        updatedLikes.add(currentUserId);
      }
      comment.likes?.clear();
      comment.likes?.addAll(updatedLikes);

      postData.refresh();

      // Call API
      final success = await _repository.reactOnComment(comment.id!);

      if (!success) {
        // Revert on failure
        appLog('Failed to react on comment - reverting');
        comment.isLiked = currentLikeState;
        await loadRealComments(refresh: true);
      } else {
        appLog('Comment reaction successful');
      }
    } catch (e) {
      appLog('Error reacting on comment: $e');
      await loadRealComments(refresh: true);
    }
  }

  //! React on a reply
  Future<void> reactOnReply(post_model.Reply reply, String commentId) async {
    if (reply.id == null) return;

    try {
      appLog('Reacting on reply: ${reply.id}');

      // Get current user ID
      final userData = await StorageService.instance.getUserData();
      final currentUserId = userData?['_id'] as String?;

      if (currentUserId == null) {
        appLog('Cannot react: User ID not found');
        return;
      }

      // Optimistically update UI
      final currentLikeState = reply.isLiked ?? false;
      reply.isLiked = !currentLikeState;

      // Update likes array
      List<dynamic> updatedLikes = List.from(reply.likes ?? []);
      if (currentLikeState) {
        updatedLikes.remove(currentUserId);
      } else {
        updatedLikes.add(currentUserId);
      }
      reply.likes?.clear();
      reply.likes?.addAll(updatedLikes);

      postData.refresh();

      // Call API
      final success = await _repository.reactOnCommentReply(
        commentId: commentId,
        replyId: reply.id!,
      );

      if (!success) {
        // Revert on failure
        appLog('Failed to react on reply - reverting');
        reply.isLiked = currentLikeState;
        await loadRealComments(refresh: true);
      } else {
        appLog('Reply reaction successful');
      }
    } catch (e) {
      appLog('Error reacting on reply: $e');
      await loadRealComments(refresh: true);
    }
  }

  //! Helper method to get reply depth
  int getReplyDepth(post_model.Reply reply) {
    int depth = 0;
    post_model.Reply? current = reply;

    // Count nested levels
    while (current?.replies != null && current!.replies!.isNotEmpty) {
      depth++;
      current = current.replies!.first;
    }

    return depth;
  }

  //! Check if reply option should be shown (max 4 levels)
  bool canReply(post_model.Comment comment) {
    // Count the maximum depth of replies
    int maxDepth = _getMaxReplyDepth(comment.replies ?? []);
    return maxDepth < 4;
  }

  int _getMaxReplyDepth(
    List<post_model.Reply> replies, [
    int currentDepth = 0,
  ]) {
    if (replies.isEmpty) return currentDepth;

    int maxDepth = currentDepth;
    for (var reply in replies) {
      int depth = _getMaxReplyDepth(reply.replies ?? [], currentDepth + 1);
      if (depth > maxDepth) maxDepth = depth;
    }
    return maxDepth;
  }

  void toggleLike(Comment comment) {
    comment.isLiked = !comment.isLiked;
    comments.refresh();
  }

  void toggleReplies(Comment comment) {
    comment.showReplies = !comment.showReplies;
    comments.refresh();
  }

  void addComment(String text) {
    if (text.trim().isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      user: "You",
      avatar: "https://i.pravatar.cc/150?img=1",
      text: text,
      likes: 0,
      replies: [],
    );

    comments.insert(0, newComment);
    commentController.clear();
  }

  void addReply(String text, Comment parentComment) {
    if (text.trim().isEmpty) return;

    final newReply = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      user: "You",
      avatar: "https://i.pravatar.cc/150?img=1",
      text: text,
      likes: 0,
      replies: [],
    );

    parentComment.replies.add(newReply);
    parentComment.showReplies = true;
    replyController.clear();
    replyingTo.value = null;
    comments.refresh();
  }

  void startReply(Comment comment) {
    replyingTo.value = comment;
  }

  void cancelReply() {
    replyingTo.value = null;
    replyController.clear();
  }

  int getTotalComments() {
    int total = 0;
    for (var comment in comments) {
      total += 1 + _countReplies(comment.replies);
    }
    return total;
  }

  int _countReplies(List<Comment> replies) {
    int count = replies.length;
    for (var reply in replies) {
      count += _countReplies(reply.replies);
    }
    return count;
  }
}

// Comment Widget
class CommentWidget extends StatelessWidget {
  final Comment comment;
  final int depth;
  final CommentsController controller;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.controller,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: depth > 0 ? 37.0 : 0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  comment.avatar,
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              const Gap(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          text: comment.user,
                          color: Color(0xFF242424),
                          fontSize: 17.12,
                          fontWeight: FontWeight.w500,
                          fontFamilyIndex: 2,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => controller.toggleLike(comment),
                          child: Column(
                            children: [
                              Icon(
                                comment.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: comment.isLiked
                                    ? Colors.red
                                    : const Color(0xFF242424),
                                size: 18,
                              ),
                              const Gap(height: 4),
                              AppText(
                                text:
                                    '${comment.likes + (comment.isLiked ? 1 : 0)}',

                                color: Color(0xFF242424),
                                fontSize: 11.12,
                                fontWeight: FontWeight.w500,
                                fontFamilyIndex: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(height: 8),
                    AppText(
                      text: comment.text,
                      color: Color(0xFF232323),
                      fontSize: 15.98,
                      fontWeight: FontWeight.w400,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      fontFamilyIndex: 2,
                    ),
                    // Text(
                    //   comment.text,
                    //   style: const TextStyle(
                    //     color: Color(0xFF232323),
                    //     fontSize: 15.98,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    //   maxLines: 4,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    if (comment.replies.isNotEmpty) ...[
                      const Gap(height: 8),
                      GestureDetector(
                        onTap: () => controller.toggleReplies(comment),
                        child: AppText(
                          text: comment.showReplies
                              ? "Hide Replies"
                              : "View Replies (${comment.replies.length})",
                          color: Color(0xFF242424),
                          fontSize: 15.12,
                          fontWeight: FontWeight.w500,
                          fontFamilyIndex: 2,
                        ),
                      ),
                    ],
                    const Gap(height: 8),
                    GestureDetector(
                      onTap: () => controller.startReply(comment),
                      child: const AppText(
                        text: "Reply",

                        color: Color(0xFF007AFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamilyIndex: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.showReplies && comment.replies.isNotEmpty) ...[
            const Gap(height: 12),
            ...comment.replies.map(
              (reply) => CommentWidget(
                comment: reply,
                controller: controller,
                depth: depth + 1,
              ),
            ),
          ],
          // Reply input for this specific comment
          Obx(() {
            if (controller.replyingTo.value?.id == comment.id) {
              return Container(
                margin: const EdgeInsets.only(top: 12, left: 37),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: controller.replyController,
                          decoration: InputDecoration(
                            hintText: "Reply to ${comment.user}...",
                            hintStyle: const TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          maxLines: null,
                          autofocus: true,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) =>
                              controller.addReply(value, comment),
                        ),
                      ),
                    ),
                    const Gap(width: 8),
                    GestureDetector(
                      onTap: () => controller.addReply(
                        controller.replyController.text,
                        comment,
                      ),
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF007AFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const Gap(width: 4),
                    GestureDetector(
                      onTap: () => controller.cancelReply(),
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

// Main Comments Bottom Sheet
class CommentsBottomSheet extends StatelessWidget {
  final String? postId;

  const CommentsBottomSheet({super.key, this.postId});

  @override
  Widget build(BuildContext context) {
    // Create controller with postId if provided
    final controller = Get.put(CommentsController(), tag: postId ?? 'default');

    // Set postId if provided
    if (postId != null && postId!.isNotEmpty) {
      controller.postId = postId!;
      // Load comments immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadRealComments();
      });
    }

    return Container(
      height: Get.height * 0.75,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(11.41),
            topRight: Radius.circular(11.41),
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Obx(() {
                  // Use real API data if available
                  if (controller.postData.value != null) {
                    final commentsCount =
                        controller.postData.value?.data?.commentsCount ?? 0;
                    return Text(
                      "$commentsCount Comments",
                      style: const TextStyle(
                        color: Color(0xFF232323),
                        fontSize: 19.40,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  // Fallback to mock data count
                  return Text(
                    "${controller.getTotalComments()} Comments",
                    style: const TextStyle(
                      color: Color(0xFF232323),
                      fontSize: 19.40,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B6B6B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Comments List
          Expanded(
            child: Obx(() {
              // Show loading indicator
              if (controller.isLoading.value &&
                  controller.postData.value == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // Use real API data if available
              if (controller.postData.value != null) {
                final comments =
                    controller.postData.value?.data?.comments ?? [];

                if (comments.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No comments yet. Be the first to comment!'),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return RealCommentWidget(
                      comment: comments[index],
                      controller: controller,
                    );
                  },
                );
              }

              // Fallback to mock data
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  return CommentWidget(
                    comment: controller.comments[index],
                    controller: controller,
                  );
                },
              );
            }),
          ),

          // Add Comment Input
          Obx(
            () => controller.replyingTo.value == null
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFE2E2E2))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: controller.commentController,
                              decoration: const InputDecoration(
                                hintText: "Add Comment",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              // onSubmitted: (value) {
                              //   // Use real API if postId is available
                              //   if (controller.postId.isNotEmpty) {
                              //     controller.addRealComment(value);
                              //   } else {
                              //     controller.addComment(value);
                              //   }
                              // },
                            ),
                          ),
                        ),
                        const Gap(width: 8),
                        Obx(
                          () => controller.isSubmitting.value
                              ? const SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    // Use real API if postId is available
                                    if (controller.postId.isNotEmpty) {
                                      controller.addRealComment(
                                        controller.commentController.text,
                                      );
                                    } else {
                                      controller.addComment(
                                        controller.commentController.text,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF007AFF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFE2E2E2))),
                      color: Color(0xFFF8F8F8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Replying to ${controller.replyingTo.value!.user}",
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.cancelReply(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Future<void> showCommentsBottomSheet({String? postId}) {
  return Get.bottomSheet(
    CommentsBottomSheet(postId: postId),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

// Real API Comment Widget
class RealCommentWidget extends StatelessWidget {
  final post_model.Comment comment;
  final CommentsController controller;
  final int depth;

  const RealCommentWidget({
    super.key,
    required this.comment,
    required this.controller,
    this.depth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: depth > 0 ? 37.0 : 0, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(width: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: comment.getUserProfile() != null
                    ? NetworkImage(comment.getUserProfile()!)
                    : null,
                child: comment.getUserProfile() == null
                    ? const Icon(Icons.person, size: 16)
                    : null,
              ),
              const Gap(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: comment.getUserName(),
                      color: Color(0xFF242424),
                      fontSize: 17.12,
                      fontWeight: FontWeight.w500,
                      fontFamilyIndex: 2,
                    ),
                    const Gap(height: 8),
                    AppText(
                      text: comment.message ?? '',
                      color: Color(0xFF232323),
                      fontSize: 15.98,
                      fontWeight: FontWeight.w400,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      fontFamilyIndex: 2,
                    ),
                    const Gap(height: 8),
                    Row(
                      children: [
                        // Like button
                        GestureDetector(
                          onTap: () => controller.reactOnComment(comment),
                          child: Row(
                            children: [
                              Icon(
                                comment.isLiked == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 16,
                                color: comment.isLiked == true
                                    ? Colors.red
                                    : Color(0xFF666666),
                              ),
                              const Gap(width: 4),
                              AppText(
                                text: '${comment.getLikesCount()}',
                                color: Color(0xFF666666),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamilyIndex: 2,
                              ),
                            ],
                          ),
                        ),
                        const Gap(width: 16),
                        AppText(
                          text: _formatDate(comment.createdAt),
                          color: Color(0xFF666666),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamilyIndex: 2,
                        ),
                        const Gap(width: 16),
                        // Only show reply button if depth is less than 3
                        if (controller.canReply(comment))
                          GestureDetector(
                            onTap: () {
                              controller.replyingToCommentId.value =
                                  comment.id ?? '';
                              controller.replyingTo.value = Comment(
                                id: 0,
                                user: comment.getUserName(),
                                avatar: '',
                                text: comment.message ?? '',
                                likes: 0,
                                replies: [],
                              );
                            },
                            child: const AppText(
                              text: "Reply",
                              color: Color(0xFF007AFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamilyIndex: 2,
                            ),
                          ),
                      ],
                    ),
                    // Show replies
                    if (comment.replies != null &&
                        comment.replies!.isNotEmpty) ...[
                      const Gap(height: 12),
                      ...comment.replies!.map(
                        (reply) => RealReplyWidget(
                          reply: reply,
                          controller: controller,
                          depth: depth + 1,
                          commentId: comment.id ?? '',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Reply input for this specific comment
          Obx(() {
            if (controller.replyingToCommentId.value == comment.id) {
              return Container(
                margin: const EdgeInsets.only(top: 12, left: 37),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: controller.replyController,
                          decoration: const InputDecoration(
                            hintText: "Write a reply...",
                            hintStyle: TextStyle(fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          maxLines: null,
                          autofocus: true,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) =>
                              controller.addRealReply(value, comment.id ?? ''),
                        ),
                      ),
                    ),
                    const Gap(width: 8),
                    Obx(
                      () => controller.isSubmitting.value
                          ? const SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : GestureDetector(
                              onTap: () => controller.addRealReply(
                                controller.replyController.text,
                                comment.id ?? '',
                              ),
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF007AFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                    ),
                    const Gap(width: 4),
                    GestureDetector(
                      onTap: () {
                        controller.replyingToCommentId.value = '';
                        controller.replyingTo.value = null;
                        controller.replyController.clear();
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }
}

// Real API Reply Widget
class RealReplyWidget extends StatelessWidget {
  final post_model.Reply reply;
  final CommentsController controller;
  final int depth;
  final String commentId; // Add commentId to track parent comment

  const RealReplyWidget({
    super.key,
    required this.reply,
    required this.controller,
    this.depth = 0,
    required this.commentId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: depth > 0 ? 20.0 : 0, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: reply.userId?.profile != null
                    ? NetworkImage(reply.userId!.profile!)
                    : null,
                child: reply.userId?.profile == null
                    ? const Icon(Icons.person, size: 14)
                    : null,
              ),
              const Gap(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: reply.userId?.fullName ?? 'User',
                      color: Color(0xFF242424),
                      fontSize: 15.12,
                      fontWeight: FontWeight.w500,
                      fontFamilyIndex: 2,
                    ),
                    const Gap(height: 4),
                    AppText(
                      text: reply.message ?? '',
                      color: Color(0xFF232323),
                      fontSize: 14.98,
                      fontWeight: FontWeight.w400,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      fontFamilyIndex: 2,
                    ),
                    const Gap(height: 6),
                    Row(
                      children: [
                        // Like button for reply
                        GestureDetector(
                          onTap: () =>
                              controller.reactOnReply(reply, commentId),
                          child: Row(
                            children: [
                              Icon(
                                reply.isLiked == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 14,
                                color: reply.isLiked == true
                                    ? Colors.red
                                    : Color(0xFF666666),
                              ),
                              const Gap(width: 4),
                              AppText(
                                text: '${reply.getLikesCount()}',
                                color: Color(0xFF666666),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamilyIndex: 2,
                              ),
                            ],
                          ),
                        ),
                        const Gap(width: 12),
                        // Only show reply button if depth is less than 4
                        if (depth < 3)
                          GestureDetector(
                            onTap: () {
                              controller.replyingToCommentId.value =
                                  reply.id ?? '';
                              controller.replyingTo.value = Comment(
                                id: 0,
                                user: reply.userId?.fullName ?? 'User',
                                avatar: '',
                                text: reply.message ?? '',
                                likes: 0,
                                replies: [],
                              );
                            },
                            child: const AppText(
                              text: "Reply",
                              color: Color(0xFF007AFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamilyIndex: 2,
                            ),
                          ),
                      ],
                    ),
                    // Nested replies
                    if (reply.replies != null && reply.replies!.isNotEmpty) ...[
                      const Gap(height: 8),
                      ...reply.replies!.map(
                        (nestedReply) => RealReplyWidget(
                          reply: nestedReply,
                          controller: controller,
                          depth: depth + 1,
                          commentId: commentId, // Pass the same commentId down
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Reply input for this specific reply
          Obx(() {
            if (controller.replyingToCommentId.value == reply.id) {
              return Container(
                margin: const EdgeInsets.only(top: 8, left: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: controller.replyController,
                          decoration: InputDecoration(
                            hintText:
                                "Reply to ${reply.userId?.fullName ?? 'User'}...",
                            hintStyle: const TextStyle(fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                          maxLines: null,
                          autofocus: true,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) =>
                              controller.addRealReply(value, reply.id ?? ''),
                        ),
                      ),
                    ),
                    const Gap(width: 6),
                    Obx(
                      () => controller.isSubmitting.value
                          ? const SizedBox(
                              height: 28,
                              width: 28,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : GestureDetector(
                              onTap: () => controller.addRealReply(
                                controller.replyController.text,
                                reply.id ?? '',
                              ),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF007AFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                    ),
                    4.width,
                    GestureDetector(
                      onTap: () {
                        controller.replyingToCommentId.value = '';
                        controller.replyingTo.value = null;
                        controller.replyController.clear();
                      },
                      child: Container(
                        height: 28.h,
                        width: 28.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
