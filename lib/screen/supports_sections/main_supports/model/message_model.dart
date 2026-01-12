/*
 * @Author: Km Muzahid
 * @Date: 2026-01-11 16:49:05
 * @Email: km.muzahid@gmail.com
 */
class MessageModel {
  final String id;
  final String message;
  final String image;
  final bool seen;
  final SenderModel sender;
  final String chatId;
  final String replyTo;
  final bool isPinned;
  final List<String> deletedByUsers;
  final List<String> reactionUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.reactionUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      image: json['image'] ?? '',
      seen: json['seen'] ?? false,
      sender: SenderModel.fromJson(json['sender'] ?? {}),
      chatId: json['chatId'] ?? '',
      replyTo: json['replyTo'] ?? '',
      isPinned: json['isPinned'] ?? false,
      deletedByUsers: List<String>.from(json['deletedByUsers'] ?? const []),
      reactionUsers: List<String>.from(json['reactionUsers'] ?? const []),
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'image': image.isEmpty ? null : image,
      'seen': seen,
      'sender': sender.toJson(),
      'chatId': chatId,
      'replyTo': replyTo.isEmpty ? null : replyTo,
      'isPinned': isPinned,
      'deletedByUsers': deletedByUsers,
      'reactionUsers': reactionUsers,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SenderModel {
  final String id;
  final String profile;
  final String fullName;
  final String role;

  SenderModel({
    required this.id,
    required this.profile,
    required this.fullName,
    required this.role,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['_id'] ?? '',
      profile: json['profile'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'profile': profile, 'fullName': fullName, 'role': role};
  }
}
