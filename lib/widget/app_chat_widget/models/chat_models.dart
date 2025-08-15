// Chat Message Model
class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? senderName;
  final String? senderAvatar;
  final List<String>? images;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.senderName,
    this.senderAvatar,
    this.images,
    this.status = MessageStatus.sent,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'] ?? '',
      isMe: json['isMe'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      images: json['images']?.cast<String>(),
      status: MessageStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isMe': isMe,
      'timestamp': timestamp.toIso8601String(),
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'images': images,
      'status': status.name,
    };
  }
}

enum MessageStatus { sending, sent, delivered, read, failed }
       