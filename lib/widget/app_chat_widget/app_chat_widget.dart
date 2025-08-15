import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/widget/app_chat_widget/controller/app_chat_widget_controller.dart';
import 'package:better_help/widget/app_chat_widget/models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Modern Chat Widget (Embeddable) - Fixed Version
class ModernChatWidget extends StatefulWidget {
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
  final bool showHeader;

  const ModernChatWidget({
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
    this.showHeader = true,
  });

  @override
  State<ModernChatWidget> createState() => _ModernChatWidgetState();
}

class _ModernChatWidgetState extends State<ModernChatWidget>
    with AutomaticKeepAliveClientMixin {
  late ModernChatController controller;
  final String _controllerTag = DateTime.now().millisecondsSinceEpoch
      .toString();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    // Use find if exists, otherwise create new
    if (Get.isRegistered<ModernChatController>(tag: widget.chatId)) {
      controller = Get.find<ModernChatController>(tag: widget.chatId);
    } else {
      controller = Get.put(
        ModernChatController(
          chatId: widget.chatId,
          onMessageSent: widget.onMessageSent,
          onImagesSent: widget.onImagesSent,
          onTypingChanged: widget.onTypingChanged,
          initialMessages: widget.initialMessages,
          primaryColor: widget.primaryColor,
        ),
        tag: widget.chatId ?? _controllerTag,
        permanent: true, // Make controller permanent
      );
    }
  }

  @override
  void dispose() {
    // Don't delete the controller here to maintain state
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (widget.showHeader) _buildChatHeader(context),
          Expanded(child: _buildMessageList()),
          _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary500 ?? widget.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          if (widget.recipientAvatar != null)
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.recipientAvatar!),
                  backgroundColor: Colors.grey[300],
                ),
                if (widget.showOnlineStatus)
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
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.subtitle != null)
                  Obx(
                    () => Text(
                      controller.isTyping.value
                          ? 'Typing...'
                          : widget.subtitle!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .8),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
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
                    (message) => _buildMessageBubble(context, message),
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
    if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
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
                color: message.isMe ? widget.primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
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

  Widget _buildTypingIndicator() {
    return Obx(() {
      if (!controller.isTyping.value) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.recipientAvatar != null
                  ? NetworkImage(widget.recipientAvatar!)
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
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTypingDot(0),
                  const Gap(width: 4),
                  _buildTypingDot(1),
                  const Gap(width: 4),
                  _buildTypingDot(2),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTypingDot(int index) {
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

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
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
                  color: widget.backgroundColor,
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
                        textInputAction: TextInputAction.newline,
                        enableInteractiveSelection: true,
                        autocorrect: true,
                        enableSuggestions: true,
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
                      ? widget.primaryColor
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
