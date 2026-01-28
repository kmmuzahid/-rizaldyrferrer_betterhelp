/*
 * @Author: Km Muzahid
 * @Date: 2026-01-12 10:09:47
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:core_kit/utils/app_log.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._();
  late IO.Socket socket;
  static final SocketService instance = SocketService._();
  bool isConnected = false;

  void connect() {
    if (isConnected) return;
    isConnected = true;
    socket = IO.io(ApiEndPoints.domain, IO.OptionBuilder().setTransports(['websocket']).build());

    socket.on('connect', (_) {
      AppLogger.info('Connected to Socket.IO server ${ApiEndPoints.domain}', tag: 'Socket');
    });

    socket.on('disconnect', (_) {
      AppLogger.debug('Disconnected from Socket.IO server');
    });

    socket.on('connect_error', (error) {
      AppLogger.error('Connection Error: $error', tag: 'socket');
    });

    socket.connect();
  }

  void startListeningNotification({required Function(dynamic data) onNotification}) {
    final id = Get.find<MyProfileScreenController>().profileData.value?.id;
    socket.on('notification::$id', (data) {
      AppLogger.info('Notification Event: $data', tag: 'Socket');
      if (data != null) {
        onNotification(data);
      }
    });
  }

  void startListeningChat({required String chatId, required Function(dynamic data) onMessage}) {
    AppLogger.apiDebug('Created Listener: $chatId', tag: 'Socket');

    socket.on('new-message::$chatId', (data) {
      AppLogger.info('Chat Event: $data', tag: 'Socket');
      if (data != null) {
        onMessage(data);
      }
    });
  }

  void stopListeningChat({required String chatId}) {
    AppLogger.apiDebug('Removed Listener: $chatId', tag: 'Socket');
    socket.off('new-message::$chatId');
  }

  void disconnect() {
    if (!isConnected) return;

    isConnected = false;
    try {
      socket.disconnect();
      socket.dispose();
      AppLogger.debug('Disconnected from server', tag: 'socket');
    } catch (_) {}
  }
}
