import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Comment Model
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
  RxList<Comment> comments = <Comment>[].obs;
  RxBool isLoading = false.obs;
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  Rx<Comment?> replyingTo = Rx<Comment?>(null);

  @override
  void onInit() {
    super.onInit();
    loadComments();
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
  const CommentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentsController());

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
                Obx(
                  () => Text(
                    "${controller.getTotalComments()} Comments",
                    style: const TextStyle(
                      color: Color(0xFF232323),
                      fontSize: 19.40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.comments.length,
                itemBuilder: (context, index) {
                  return CommentWidget(
                    comment: controller.comments[index],
                    controller: controller,
                  );
                },
              ),
            ),
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
                              onSubmitted: (value) =>
                                  controller.addComment(value),
                            ),
                          ),
                        ),
                        const Gap(width: 8),
                        GestureDetector(
                          onTap: () => controller.addComment(
                            controller.commentController.text,
                          ),
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

Future<void> showCommentsBottomSheet() {
  return Get.bottomSheet(
    const CommentsBottomSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
