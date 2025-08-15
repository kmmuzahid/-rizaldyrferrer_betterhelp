import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:better_help/widget/app_chat_widget/controller/app_chat_widget_controller.dart';
import 'package:better_help/widget/app_chat_widget/models/chat_models.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

// Chat Service for Socket and API Integration
class ChatService extends GetxService {
  static ChatService get instance => Get.find<ChatService>();

  IO.Socket? _socket;
  final String baseUrl;
  final String? apiKey;
  final Map<String, String> headers;

  // Reactive states
  final RxBool isConnected = false.obs;
  final RxString connectionStatus = 'Disconnected'.obs;

  // Active chat controllers
  final Map<String, ModernChatController> _activeChats = {};

  ChatService({required this.baseUrl, this.apiKey, this.headers = const {}});

  @override
  void onInit() {
    super.onInit();
    _initializeSocket();
  }

  @override
  void onClose() {
    _socket?.disconnect();
    super.onClose();
  }

  // Initialize Socket Connection
  void _initializeSocket() {
    try {
      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setExtraHeaders(headers)
            .build(),
      );

      _setupSocketListeners();
    } catch (e) {
      log('Socket initialization error: $e');
      connectionStatus.value = 'Connection Failed';
    }
  }

  void _setupSocketListeners() {
    _socket?.onConnect((_) {
      isConnected.value = true;
      connectionStatus.value = 'Connected';
      log('Socket connected');
    });

    _socket?.onDisconnect((_) {
      isConnected.value = false;
      connectionStatus.value = 'Disconnected';
      log('Socket disconnected');
    });

    _socket?.onReconnect((_) {
      isConnected.value = true;
      connectionStatus.value = 'Reconnected';
      log('Socket reconnected');
    });

    _socket?.onConnectError((data) {
      isConnected.value = false;
      connectionStatus.value = 'Connection Error';
      log('Socket connection error: $data');
    });

    // Listen for incoming messages
    _socket?.on('message', (data) {
      _handleIncomingMessage(data);
    });

    // Listen for typing indicators
    _socket?.on('typing', (data) {
      _handleTypingIndicator(data);
    });

    // Listen for message status updates
    _socket?.on('message_status', (data) {
      _handleMessageStatus(data);
    });

    // Listen for user online status
    _socket?.on('user_status', (data) {
      _handleUserStatus(data);
    });
  }

  // Register chat controller
  void registerChat(String chatId, ModernChatController controller) {
    _activeChats[chatId] = controller;

    // Join chat room
    _socket?.emit('join_chat', {'chatId': chatId});
  }

  // Unregister chat controller
  void unregisterChat(String chatId) {
    _activeChats.remove(chatId);

    // Leave chat room
    _socket?.emit('leave_chat', {'chatId': chatId});
  }

  // Send message via socket
  void sendMessage({
    required String chatId,
    required String message,
    String? recipientId,
    Map<String, dynamic>? metadata,
  }) {
    if (!isConnected.value) {
      _sendMessageViaAPI(
        chatId: chatId,
        message: message,
        recipientId: recipientId,
      );
      return;
    }

    final messageData = {
      'chatId': chatId,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'senderId': _getCurrentUserId(),
      if (recipientId != null) 'recipientId': recipientId,
      if (metadata != null) ...metadata,
    };

    _socket?.emit('send_message', messageData);
  }

  // Send images via socket
  void sendImages({
    required String chatId,
    required List<String> imagePaths,
    String? recipientId,
    String? caption,
  }) async {
    try {
      // Upload images first
      final uploadedUrls = await _uploadImages(imagePaths);

      if (!isConnected.value) {
        _sendImagesViaAPI(
          chatId: chatId,
          imageUrls: uploadedUrls,
          recipientId: recipientId,
          caption: caption,
        );
        return;
      }

      final messageData = {
        'chatId': chatId,
        'images': uploadedUrls,
        'message': caption ?? '',
        'timestamp': DateTime.now().toIso8601String(),
        'senderId': _getCurrentUserId(),
        if (recipientId != null) 'recipientId': recipientId,
        'type': 'images',
      };

      _socket?.emit('send_message', messageData);
    } catch (e) {
      log('Error sending images: $e');
      Get.snackbar('Error', 'Failed to send images');
    }
  }

  // Send typing indicator
  void sendTypingIndicator({
    required String chatId,
    required bool isTyping,
    String? recipientId,
  }) {
    if (!isConnected.value) return;

    _socket?.emit('typing', {
      'chatId': chatId,
      'isTyping': isTyping,
      'senderId': _getCurrentUserId(),
      if (recipientId != null) 'recipientId': recipientId,
    });
  }

  // Handle incoming messages
  void _handleIncomingMessage(dynamic data) {
    try {
      final messageData = Map<String, dynamic>.from(data);
      final chatId = messageData['chatId'] as String;
      final controller = _activeChats[chatId];

      if (controller != null) {
        controller.addReceivedMessage(
          id:
              messageData['id'] ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          text: messageData['message'] ?? '',
          timestamp: DateTime.parse(messageData['timestamp']),
          senderName: messageData['senderName'],
          senderAvatar: messageData['senderAvatar'],
          images: messageData['images']?.cast<String>(),
        );
      }
    } catch (e) {
      log('Error handling incoming message: $e');
    }
  }

  // Handle typing indicators
  void _handleTypingIndicator(dynamic data) {
    try {
      final typingData = Map<String, dynamic>.from(data);
      final chatId = typingData['chatId'] as String;
      final isTyping = typingData['isTyping'] as bool;
      final controller = _activeChats[chatId];

      if (controller != null) {
        controller.setTypingStatus(isTyping);
      }
    } catch (e) {
      log('Error handling typing indicator: $e');
    }
  }

  // Handle message status updates
  void _handleMessageStatus(dynamic data) {
    try {
      final statusData = Map<String, dynamic>.from(data);
      final chatId = statusData['chatId'] as String;
      final messageId = statusData['messageId'] as String;
      final status = statusData['status'] as String;
      final controller = _activeChats[chatId];

      if (controller != null) {
        final messageStatus = MessageStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => MessageStatus.sent,
        );
        controller.updateMessageStatus(messageId, messageStatus);
      }
    } catch (e) {
      log('Error handling message status: $e');
    }
  }

  // Handle user status updates
  void _handleUserStatus(dynamic data) {
    try {
      final statusData = Map<String, dynamic>.from(data);
      // Handle user online/offline status
      log('User status update: $statusData');
    } catch (e) {
      log('Error handling user status: $e');
    }
  }

  // Fallback API methods when socket is not connected
  Future<void> _sendMessageViaAPI({
    required String chatId,
    required String message,
    String? recipientId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/messages'),
        headers: {
          'Content-Type': 'application/json',
          if (apiKey != null) 'Authorization': 'Bearer $apiKey',
          ...headers,
        },
        body: jsonEncode({
          'chatId': chatId,
          'message': message,
          'senderId': _getCurrentUserId(),
          if (recipientId != null) 'recipientId': recipientId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      log('API send message error: $e');
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  Future<void> _sendImagesViaAPI({
    required String chatId,
    required List<String> imageUrls,
    String? recipientId,
    String? caption,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/messages'),
        headers: {
          'Content-Type': 'application/json',
          if (apiKey != null) 'Authorization': 'Bearer $apiKey',
          ...headers,
        },
        body: jsonEncode({
          'chatId': chatId,
          'message': caption ?? '',
          'images': imageUrls,
          'senderId': _getCurrentUserId(),
          if (recipientId != null) 'recipientId': recipientId,
          'type': 'images',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send images: ${response.statusCode}');
      }
    } catch (e) {
      log('API send images error: $e');
      Get.snackbar('Error', 'Failed to send images');
    }
  }

  // Upload images to server
  Future<List<String>> _uploadImages(List<String> imagePaths) async {
    final uploadedUrls = <String>[];

    for (final imagePath in imagePaths) {
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/api/upload'),
        );

        request.headers.addAll({
          if (apiKey != null) 'Authorization': 'Bearer $apiKey',
          ...headers,
        });

        request.files.add(
          await http.MultipartFile.fromPath('image', imagePath),
        );

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final data = jsonDecode(responseData);
          uploadedUrls.add(data['url']);
        } else {
          throw Exception('Upload failed: ${response.statusCode}');
        }
      } catch (e) {
        log('Image upload error: $e');
        throw Exception('Failed to upload image: $imagePath');
      }
    }

    return uploadedUrls;
  }

  // Fetch chat history from API
  Future<List<ChatMessage>> getChatHistory(
    String chatId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/chats/$chatId/messages?limit=$limit&offset=$offset',
        ),
        headers: {
          if (apiKey != null) 'Authorization': 'Bearer $apiKey',
          ...headers,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = (data['messages'] as List)
            .map((msg) => ChatMessage.fromJson(msg))
            .toList();
        return messages;
      } else {
        throw Exception('Failed to fetch chat history: ${response.statusCode}');
      }
    } catch (e) {
      log('Fetch chat history error: $e');
      return [];
    }
  }

  // Get current user ID (implement based on your auth system)
  String _getCurrentUserId() {
    // Replace with your actual user ID logic
    return 'current_user_id';
  }

  // Reconnect socket manually
  void reconnect() {
    _socket?.disconnect();
    _socket?.connect();
  }

  // Get connection status
  String get status => connectionStatus.value;
  bool get connected => isConnected.value;
}

// Easy-to-use Chat Integration Mixin
mixin ChatIntegration {
  late ModernChatController chatController;
  late String chatId;

  void initializeChat({
    required String id,
    String? recipientId,
    List<ChatMessage>? initialMessages,
  }) {
    chatId = id;

    chatController = Get.put(
      ModernChatController(
        chatId: chatId,
        initialMessages: initialMessages,
        onMessageSent: (message) => _handleMessageSent(message, recipientId),
        onImagesSent: (imagePaths) =>
            _handleImagesSent(imagePaths, recipientId),
        onTypingChanged: () => _handleTypingChanged(recipientId),
      ),
      tag: chatId,
    );

    // Register with chat service
    ChatService.instance.registerChat(chatId, chatController);

    // Load chat history
    _loadChatHistory();
  }

  void _handleMessageSent(String message, String? recipientId) {
    ChatService.instance.sendMessage(
      chatId: chatId,
      message: message,
      recipientId: recipientId,
    );
  }

  void _handleImagesSent(List<String> imagePaths, String? recipientId) {
    ChatService.instance.sendImages(
      chatId: chatId,
      imagePaths: imagePaths,
      recipientId: recipientId,
    );
  }

  void _handleTypingChanged(String? recipientId) {
    ChatService.instance.sendTypingIndicator(
      chatId: chatId,
      isTyping: chatController.hasText.value,
      recipientId: recipientId,
    );
  }

  void _loadChatHistory() async {
    final history = await ChatService.instance.getChatHistory(chatId);
    if (history.isNotEmpty) {
      chatController.loadMessages(history);
    }
  }

  void disposeChat() {
    ChatService.instance.unregisterChat(chatId);
    Get.delete<ModernChatController>(tag: chatId);
  }
}
