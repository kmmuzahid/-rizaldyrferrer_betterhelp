import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Singleton service for managing local notifications
class NotificationService {
  // Private constructor
  NotificationService._();

  // Singleton instance
  static final NotificationService _instance = NotificationService._();

  // Getter for singleton instance
  static NotificationService get instance => _instance;

  // Flutter Local Notifications Plugin instance
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Notification ID counter
  int _notificationId = 0;

  Future<void> initialize(Function(NotificationResponse) onNotificationTapped) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize notification service
    await _initialize(
      onNotificationTapped: (NotificationResponse response) {
        onNotificationTapped(response);
      },
      onBackgroundNotificationTapped: onNotificationTapped,
    );

    // Request permissions
    await requestPermissions();
  }

  /// Initialize the notification service
  Future<void> _initialize({
    required void Function(NotificationResponse) onNotificationTapped,
    void Function(NotificationResponse)? onBackgroundNotificationTapped,
    List<DarwinNotificationCategory>? darwinNotificationCategories,
  }) async {
    await _configureLocalTimeZone();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS/macOS initialization settings
    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories ?? [],
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTapped,
    );
  }

  /// Configure local timezone
  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    if (Platform.isWindows) {
      return;
    }
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.identifier));
  }

  /// Request notification permissions (iOS/macOS)
  Future<bool?> requestPermissions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: alert, badge: badge, sound: sound);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission();
    }
    return null;
  }

  /// Check if notifications are enabled (Android)
  Future<bool?> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      return await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
    return null;
  }

  /// Show a simple notification
  Future<void> showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    final int notificationId = id ?? _notificationId++;

    final NotificationDetails details =
        notificationDetails ??
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Channel',
            channelDescription: 'Default notification channel',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        );

    await _notificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Show notification with custom sound
  Future<void> showNotificationWithSound({
    int? id,
    required String title,
    required String body,
    required String soundFileName,
    String? payload,
  }) async {
    final int notificationId = id ?? _notificationId++;

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sound_channel',
      'Sound Channel',
      channelDescription: 'Notification channel with custom sound',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(
        soundFileName.replaceAll('.mp3', '').replaceAll('.wav', ''),
      ),
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(sound: soundFileName);

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Schedule a notification
  Future<void> scheduleNotification({
    int? id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationDetails? notificationDetails,
    AndroidScheduleMode androidScheduleMode = AndroidScheduleMode.exactAllowWhileIdle,
  }) async {
    final int notificationId = id ?? _notificationId++;

    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);

    final NotificationDetails details =
        notificationDetails ??
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'scheduled_channel',
            'Scheduled Channel',
            channelDescription: 'Scheduled notification channel',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
          macOS: DarwinNotificationDetails(),
        );

    await _notificationsPlugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: scheduledTZDate,
      notificationDetails: details,
      androidScheduleMode: androidScheduleMode,
      payload: payload,
    );
  }

  /// Show notification with big picture (Android)
  Future<void> showBigPictureNotification({
    int? id,
    required String title,
    required String body,
    required String imagePath,
    String? payload,
  }) async {
    if (!Platform.isAndroid) return;

    final int notificationId = id ?? _notificationId++;

    final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath),
      contentTitle: title,
      summaryText: body,
    );

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'big_picture_channel',
      'Big Picture Channel',
      channelDescription: 'Notification channel for big picture notifications',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
    );

    final NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Show notification with progress bar (Android)
  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
    String? payload,
  }) async {
    if (!Platform.isAndroid) return;

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'progress_channel',
      'Progress Channel',
      channelDescription: 'Notification channel for progress notifications',
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
    );

    final NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Get pending notification requests
  Future<List<PendingNotificationRequest>> getPendingNotificationRequests() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Get active notifications
  Future<List<ActiveNotification>?> getActiveNotifications() async {
    return await _notificationsPlugin.getActiveNotifications();
  }

  /// Create a notification channel (Android)
  Future<void> createNotificationChannel({
    required String id,
    required String name,
    String? description,
    Importance importance = Importance.defaultImportance,
  }) async {
    if (!Platform.isAndroid) return;

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      id,
      name,
      description: description,
      importance: importance,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Delete a notification channel (Android)
  Future<void> deleteNotificationChannel(String channelId) async {
    if (!Platform.isAndroid) return;

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId: channelId);
  }

  /// Get the plugin instance
  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;
}
