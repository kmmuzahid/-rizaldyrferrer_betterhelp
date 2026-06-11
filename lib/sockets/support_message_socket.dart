/*
 * @Author: Km Muzahid
 * @Date: 2026-01-12 10:09:47
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:core_kit/utils/ck_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._();
  late IO.Socket socket;
  static final SocketService instance = SocketService._();
  bool isConnected = false;

  void connect() {
    if (isConnected) return;
    isConnected = true;
    socket = IO.io(
      ApiEndPoints.domain,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.on('connect', (_) {
      CkLogger.info(
        'Connected to Socket.IO server ${ApiEndPoints.domain}',
        tag: 'Socket',
      );
    });

    socket.on('disconnect', (_) {
      CkLogger.debug('Disconnected from Socket.IO server');
    });

    socket.on('connect_error', (error) {
      CkLogger.error('Connection Error: $error', tag: 'socket');
    });

    socket.connect();
  }

  void startListeningNotification({
    required Function(dynamic data) onNotification,
  }) {
    final id = ckAuth.profile?.id;
    socket.on('notification::$id', (data) {
      CkLogger.info('Notification Event: $data', tag: 'Socket');
      if (data != null) {
        onNotification(data);
      }
    });
  }

  void startListeningChat({
    required String chatId,
    required Function(dynamic data) onMessage,
  }) {
    CkLogger.apiDebug('Created Listener: $chatId', tag: 'Socket');

    socket.on('new-message::$chatId', (data) {
      CkLogger.info('Chat Event: $data', tag: 'Socket');
      if (data != null) {
        onMessage(data);
      }
    });
  }

  void stopListeningChat({required String chatId}) {
    CkLogger.apiDebug('Removed Listener: $chatId', tag: 'Socket');
    socket.off('new-message::$chatId');
  }

  void disconnect() {
    if (!isConnected) return;

    isConnected = false;
    try {
      socket.disconnect();
      socket.dispose();
      CkLogger.debug('Disconnected from server', tag: 'socket');
    } catch (_) {}
  }
}
