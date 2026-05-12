/*
 * @Author: Km Muzahid
 * @Date: 2026-01-11 16:49:05
 * @Email: km.muzahid@gmail.com
 */
class MessageModel {
  final String id;
  final String message;
  final String image; // Default to empty string
  final bool seen;
  final Sender sender;
  final String chatId;
  final String replyTo; // Default to empty string
  final bool isPinned;
  final List<String> deletedByUsers;
  final String messageType;
  final List<dynamic> reactionUsers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isReply;
  final String? status;
  final String? taskId;

  MessageModel({
    required this.id,
    required this.message,
    required this.image,
    required this.seen,
    required this.sender,
    required this.chatId,
    required this.replyTo,
    required this.isPinned,
    required this.deletedByUsers,
    required this.messageType,
    required this.reactionUsers,
    required this.createdAt,
    required this.updatedAt,
    required this.isReply,
    this.status,
    this.taskId,
  });

  factory MessageModel.fromJson(Map<String, dynamic>? json) {
    return MessageModel(
      id: json?['_id'] ?? '',
      message: json?['message'] ?? '',
      image: json?['image'] ?? '',
      seen: json?['seen'] ?? false,
      sender: Sender.fromJson(json?['sender']),
      chatId: json?['chatId'] ?? '',
      replyTo: json?['replyTo'] ?? '',
      isPinned: json?['isPinned'] ?? false,
      deletedByUsers: List<String>.from(json?['deletedByUsers'] ?? []),
      messageType: json?['messageType'] ?? 'text',
      reactionUsers: List<dynamic>.from(json?['reactionUsers'] ?? []),
      createdAt: DateTime.tryParse(json?['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json?['updatedAt'] ?? '') ?? DateTime.now(),
      isReply: json?['isReply'] ?? false,
      status: json?['taskStatus'] ?? '',
      taskId: json?['taskId'] ?? '',
    );
  }

  //copywith
  MessageModel copyWith({
    String? id,
    String? message,
    String? image,
    bool? seen,
    Sender? sender,
    String? chatId,
    String? replyTo,
    bool? isPinned,
    List<String>? deletedByUsers,
    String? messageType,
    List<dynamic>? reactionUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isResponseSent,
    String? status,
    String? taskId,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      image: image ?? this.image,
      seen: seen ?? this.seen,
      sender: sender ?? this.sender,
      chatId: chatId ?? this.chatId,
      replyTo: replyTo ?? this.replyTo,
      isPinned: isPinned ?? this.isPinned,
      deletedByUsers: deletedByUsers ?? this.deletedByUsers,
      messageType: messageType ?? this.messageType,
      reactionUsers: reactionUsers ?? this.reactionUsers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isReply: isResponseSent ?? isReply,
      status: status ?? this.status,
      taskId: taskId ?? this.taskId,
    );
  }
}

class Sender {
  final String id;
  final String profile;
  final String fullName;
  final String role;

  Sender({
    required this.id,
    required this.profile,
    required this.fullName,
    required this.role,
  });

  factory Sender.fromJson(Map<String, dynamic>? json) {
    return Sender(
      id: json?['_id'] ?? '',
      profile: json?['profile'] ?? '',
      fullName: json?['fullName'] ?? 'Unknown User',
      role: json?['role'] ?? 'user',
    );
  }
}
