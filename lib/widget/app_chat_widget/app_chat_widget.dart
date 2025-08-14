import 'dart:io';
import 'package:better_help/widget/app_chat_widget/controller/app_chat_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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

// Modern Chat Screen Widget
class ModernChatScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? chatId;
  final String? recipientAvatar;
  final bool showOnlineStatus;
  final Color primaryColor;
  final Color backgroundColor;
  final Function(String message)? onMessageSent;
  final Function(List<String> imagePaths)? onImagesSent;
  final Function()? onTypingChanged;
  final List<ChatMessage>? initialMessages;

  const ModernChatScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.chatId,
    this.recipientAvatar,
    this.showOnlineStatus = false,
    this.primaryColor = const Color(0xFF4DB6AC),
    this.backgroundColor = const Color(0xFFF5F7FA),
    this.onMessageSent,
    this.onImagesSent,
    this.onTypingChanged,
    this.initialMessages,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ModernChatController(
        chatId: chatId,
        onMessageSent: onMessageSent,
        onImagesSent: onImagesSent,
        onTypingChanged: onTypingChanged,
        initialMessages: initialMessages,
        primaryColor: primaryColor,
      ),
      tag: chatId ?? 'default_chat',
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, controller),
      body: Expanded(
        child: Column(
          children: [
            Expanded(child: _buildMessageList(controller)),
            _buildTypingIndicator(controller),
            _buildInputArea(controller),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ModernChatController controller,
  ) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          if (recipientAvatar != null)
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(recipientAvatar!),
                  backgroundColor: Colors.grey[300],
                ),
                if (showOnlineStatus)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Obx(
                    () => Text(
                      controller.isTyping.value ? 'Typing...' : subtitle!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            // Show more options
          },
        ),
      ],
    );
  }

  Widget _buildMessageList(ModernChatController controller) {
    return Obx(() {
      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No messages yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Start a conversation!',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.groupedMessages.length,
        itemBuilder: (context, index) {
          final group = controller.groupedMessages[index];
          return Column(
            children: [
              if (group['showDate']) _buildDateHeader(group['date']),
              ...group['messages']
                  .map<Widget>(
                    (message) =>
                        _buildMessageBubble(context, message, controller),
                  )
                  .toList(),
            ],
          );
        },
      );
    });
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatDateHeader(date),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) return 'Today';
    if (messageDate == today.subtract(const Duration(days: 1)))
      return 'Yesterday';

    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildMessageBubble(
    BuildContext context,
    ChatMessage message,
    ModernChatController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe && message.senderAvatar != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.senderAvatar!),
                backgroundColor: Colors.grey[300],
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe ? primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.images != null && message.images!.isNotEmpty)
                    _buildImageGrid(message.images!),
                  if (message.text.isNotEmpty)
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.formatTime(message.timestamp),
                        style: TextStyle(
                          color: message.isMe
                              ? Colors.white70
                              : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        _buildMessageStatusIcon(message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe && message.senderAvatar != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(message.senderAvatar!),
                backgroundColor: Colors.grey[300],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            images[0],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.error, color: Colors.grey),
              );
            },
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: images.length > 4 ? 3 : 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: images.length > 6 ? 6 : images.length,
        itemBuilder: (context, index) {
          if (index == 5 && images.length > 6) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '+${images.length - 5}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.grey),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation(Colors.white70),
          ),
        );
      case MessageStatus.sent:
        return Icon(Icons.check, size: 14, color: Colors.white70);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 14, color: Colors.white70);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 14, color: Colors.blue[200]);
      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 14, color: Colors.red[300]);
    }
  }

  Widget _buildTypingIndicator(ModernChatController controller) {
    return Obx(() {
      if (!controller.isTyping.value) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: recipientAvatar != null
                  ? NetworkImage(recipientAvatar!)
                  : null,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTypingDot(0, controller),
                  const SizedBox(width: 4),
                  _buildTypingDot(1, controller),
                  const SizedBox(width: 4),
                  _buildTypingDot(2, controller),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTypingDot(int index, ModernChatController controller) {
    return Obx(() {
      final opacity = controller.typingAnimation.value > (index * 0.3)
          ? 1.0
          : 0.3;
      return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[600],
            shape: BoxShape.circle,
          ),
        ),
      );
    });
  }

  Widget _buildInputArea(ModernChatController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.textController,
                        decoration: const InputDecoration(
                          hintText: 'Write a message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onChanged: controller.onTextChanged,
                        onSubmitted: (_) => controller.sendMessage(),
                        maxLines: null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                      onPressed: controller.attachFile,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: controller.hasText.value
                      ? primaryColor
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    controller.hasText.value ? Icons.send : Icons.mic,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: controller.hasText.value
                      ? controller.sendMessage
                      : controller.startVoiceRecording,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
