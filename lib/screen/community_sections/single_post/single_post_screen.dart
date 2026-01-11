import 'package:better_help/screen/community_sections/single_post/controller/single_post_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SinglePostScreen extends StatelessWidget {
  const SinglePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SinglePostController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: AppColors.primary500,
      ),
      body: Obx(() {
        if (controller.isLoadingPost.value &&
            controller.postData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final post = controller.postData.value?.data;
        if (post == null) {
          return const Center(child: Text('Failed to load post'));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshPost,
          child: Column(
            children: [
              // Post content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: post.userId?.profile != null
                                ? NetworkImage(post.userId!.profile!)
                                : null,
                            child: post.userId?.profile == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userId?.fullName ?? 'Anonymous',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  _formatDate(post.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Post description
                      Text(
                        post.description ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),

                      // Post stats
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text('${post.likesCount ?? 0} likes'),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.comment,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text('${post.commentsCount ?? 0} comments'),
                        ],
                      ),
                      const Divider(height: 32),

                      // Comments section
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Comments list
                      if (post.comments != null && post.comments!.isNotEmpty)
                        ...post.comments!.map(
                          (comment) =>
                              _buildCommentItem(context, controller, comment),
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('No comments yet'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Comment input section
              _buildCommentInput(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    SinglePostController controller,
    dynamic comment,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                child: const Icon(Icons.person, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.message ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatDate(comment.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () =>
                              controller.setReplyMode(comment.id ?? '', 'User'),
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              color: AppColors.primary500,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Replies
          if (comment.replies != null && comment.replies!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 12),
              child: Column(
                children: comment.replies!.map<Widget>((reply) {
                  return _buildReplyItem(context, controller, reply);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReplyItem(
    BuildContext context,
    SinglePostController controller,
    dynamic reply,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.userId?.fullName ?? 'User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(reply.message ?? '', style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(reply.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => controller.setReplyMode(
                        reply.id ?? '',
                        reply.userId?.fullName ?? 'User',
                      ),
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: AppColors.primary500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(SinglePostController controller) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply indicator
            if (controller.isReplyMode.value)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Replying to ${controller.replyingToUserName.value}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.cancelReply,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

            // Input field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.isReplyMode.value
                        ? controller.replyController
                        : controller.commentController,
                    decoration: InputDecoration(
                      hintText: controller.isReplyMode.value
                          ? 'Write a reply...'
                          : 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                controller.isSubmittingComment.value
                    ? const CircularProgressIndicator()
                    : IconButton(
                        onPressed: () {
                          if (controller.isReplyMode.value) {
                            controller.submitReply();
                          } else {
                            controller.submitComment();
                          }
                        },
                        icon: Icon(Icons.send, color: AppColors.primary500),
                      ),
              ],
            ),
          ],
        ),
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
