import 'dart:async';
import 'dart:developer';

import 'package:better_help/widget/app_chat_widget/models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ModernChatController extends GetxController
    with GetTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  // Configuration
  final String? chatId;
  final Function(String message)? onMessageSent;
  final Function(List<String> imagePaths)? onImagesSent;
  final Function()? onTypingChanged;
  final Color primaryColor;

  // Reactive variables
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool hasText = false.obs;
  final RxDouble typingAnimation = 0.0.obs;

  // Animation controllers
  late AnimationController typingAnimationController;
  Timer? typingTimer;
  Timer? stopTypingTimer;

  // Text change debouncer to prevent excessive rebuilds
  Timer? _textChangeDebounce;

  ModernChatController({
    this.chatId,
    this.onMessageSent,
    this.onImagesSent,
    this.onTypingChanged,
    List<ChatMessage>? initialMessages,
    this.primaryColor = const Color(0xFF4DB6AC),
  }) {
    if (initialMessages != null) {
      messages.assignAll(initialMessages);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _setupTextController();
  }

  @override
  void onClose() {
    _textChangeDebounce?.cancel();
    textController.dispose();
    scrollController.dispose();
    typingAnimationController.dispose();
    typingTimer?.cancel();
    stopTypingTimer?.cancel();
    super.onClose();
  }

  void _setupTextController() {
    // Remove existing listener if any
    textController.removeListener(_onTextChanged);
    // Add listener
    textController.addListener(_onTextChanged);
  }

  void _initializeAnimations() {
    typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(
          CurvedAnimation(
            parent: typingAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    animation.addListener(() {
      typingAnimation.value = animation.value;
    });

    typingAnimationController.repeat();
  }

  void _onTextChanged() {
    // Debounce text changes to prevent excessive rebuilds
    if (_textChangeDebounce?.isActive ?? false) {
      _textChangeDebounce!.cancel();
    }

    _textChangeDebounce = Timer(const Duration(milliseconds: 100), () {
      final text = textController.text.trim();
      final wasEmpty = !hasText.value;
      final isEmpty = text.isEmpty;

      // Only update if state actually changed
      if (wasEmpty != isEmpty) {
        hasText.value = !isEmpty;
      }

      // Handle typing indicator
      if (text.isNotEmpty) {
        _startTyping();
      } else {
        _stopTyping();
      }
    });
  }

  void _startTyping() {
    if (!isTyping.value) {
      onTypingChanged?.call();
    }

    // Cancel existing timer
    stopTypingTimer?.cancel();

    // Set stop typing timer
    stopTypingTimer = Timer(const Duration(seconds: 2), () {
      _stopTyping();
    });
  }

  void _stopTyping() {
    stopTypingTimer?.cancel();
    if (isTyping.value) {
      onTypingChanged?.call();
    }
  }

  void onTextChanged(String text) {
    // This method is called from the TextField onChanged
    // The actual handling is done by the TextController listener
    // to avoid duplicate processing
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Add message to UI immediately
    messages.add(message);

    // Clear text field and update state
    textController.clear();
    hasText.value = false;

    // Scroll to bottom
    _scrollToBottom();

    // Update status to sent after a delay (simulating network)
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageStatus(message.id, MessageStatus.sent);
    });

    // Trigger callback
    onMessageSent?.call(text);
  }

  void sendImages(List<String> imagePaths) {
    if (imagePaths.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
      isMe: true,
      timestamp: DateTime.now(),
      images: imagePaths,
      status: MessageStatus.sending,
    );

    messages.add(message);
    _scrollToBottom();

    // Update status
    Future.delayed(const Duration(seconds: 1), () {
      _updateMessageStatus(message.id, MessageStatus.sent);
    });

    onImagesSent?.call(imagePaths);
  }

  Future<void> attachFile() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final imagePaths = images.map((img) => img.path).toList();
        sendImages(imagePaths);
      }
    } catch (e) {
      log('Error picking images: $e');
      Get.snackbar(
        'Error',
        'Failed to pick images',
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red[100],
      );
    }
  }

  void startVoiceRecording() {
    // Implement voice recording logic
    Get.snackbar(
      'Voice Recording',
      'Voice recording feature coming soon!',
      snackPosition: SnackPosition.bottom,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  // Group messages by date for display
  List<Map<String, dynamic>> get groupedMessages {
    final grouped = <Map<String, dynamic>>[];
    DateTime? lastDate;

    for (final message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || !_isSameDay(lastDate, messageDate)) {
        grouped.add({
          'date': messageDate,
          'showDate': true,
          'messages': [message],
        });
        lastDate = messageDate;
      } else {
        grouped.last['messages'].add(message);
      }
    }

    return grouped;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Backend integration methods
  void addReceivedMessage({
    required String id,
    required String text,
    required DateTime timestamp,
    String? senderName,
    String? senderAvatar,
    List<String>? images,
  }) {
    final message = ChatMessage(
      id: id,
      text: text,
      isMe: false,
      timestamp: timestamp,
      senderName: senderName,
      senderAvatar: senderAvatar,
      images: images,
    );

    messages.add(message);
    _scrollToBottom();
  }

  void _updateMessageStatus(String messageId, MessageStatus status) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      final updatedMessage = ChatMessage(
        id: messages[index].id,
        text: messages[index].text,
        isMe: messages[index].isMe,
        timestamp: messages[index].timestamp,
        senderName: messages[index].senderName,
        senderAvatar: messages[index].senderAvatar,
        images: messages[index].images,
        status: status,
      );
      messages[index] = updatedMessage;
    }
  }

  void updateMessageStatus(String messageId, MessageStatus status) {
    _updateMessageStatus(messageId, status);
  }

  void setTypingStatus(bool typing) {
    isTyping.value = typing;
  }

  void clearMessages() {
    messages.clear();
  }

  void loadMessages(List<ChatMessage> messageList) {
    messages.assignAll(messageList);
    _scrollToBottom();
  }

  // Simulate receiving a message (for testing)
  void simulateReceivedMessage(String text) {
    Future.delayed(const Duration(seconds: 1), () {
      addReceivedMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        timestamp: DateTime.now(),
        senderName: 'Health Assistant',
        senderAvatar: 'https://via.placeholder.com/40',
      );
    });
  }

  // Method to refresh controller state if needed
  void refreshController() {
    _setupTextController();
  }
}
