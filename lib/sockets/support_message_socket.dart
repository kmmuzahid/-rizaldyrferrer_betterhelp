/*
 * @Author: Km Muzahid
 * @Date: 2026-01-12 10:09:47
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:core_kit/utils/app_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._();
  late IO.Socket socket;
  static final SocketService instance = SocketService._();
  bool isConnected = false;

  void connect() {
    if (isConnected) return;
    isConnected = true;
    socket = IO.io(AppApiurl.domain, IO.OptionBuilder().setTransports(['websocket']).build());

    socket.on('connect', (_) {
      AppLogger.info('Connected to Socket.IO server ${AppApiurl.domain}', tag: 'Socket');
    });

    socket.on('disconnect', (_) {
      AppLogger.debug('Disconnected from Socket.IO server');
    });

    socket.on('connect_error', (error) {
      AppLogger.error('Connection Error: $error', tag: 'socket');
    });

    socket.connect();
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
