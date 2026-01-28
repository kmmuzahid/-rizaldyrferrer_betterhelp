/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 12:00:50
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/notification/model/notification_model.dart';
import 'package:better_help/screen/notification/notification_screen_controller.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationScreenController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllNotification();
    });
    return Scaffold(
      appBar: AppBarWithBack(
        text: 'Notification',
        onBackTap: () {
          controller.getUnreadCount();
          controller.notificationList.clear();
        },
        actions: [markAllReadButton(controller)],
      ),
      body: SafeArea(
        child: Obx(
          () => SmartListLoader(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            isLoading: controller.isLoading.value,
            onRefresh: () => controller.getAllNotification(isRefresh: true),
            limit: 20,
            onLoadMore: (page) => controller.getAllNotification(page: page),
            itemCount: controller.notificationList.length,
            itemBuilder: (context, index) {
              final notification = controller.notificationList[index];
              return NotificationItem(
                notification: notification,
                controller: controller,
                index: index,
              );
            },
          ),
        ),
      ),
    );
  }

  markAllReadButton(NotificationScreenController controller) {
    return GestureDetector(
      child: CommonText(
        right: 10,
        textColor: Colors.cyan,
        text: 'Read All',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      onTap: () => controller.markAllRead(),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final NotificationScreenController controller;
  final int index;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the type
    Color typeColor;
    if (!notification.isRead) {
      typeColor = Colors.cyan;
    } else {
      typeColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        leading: Icon(Icons.notifications, color: typeColor),
        title: Text(
          notification.message,
          style: TextStyle(
            color: notification.isRead ? Colors.grey : Colors.black, // Read/Unread Title Color
          ),
        ),
        trailing: CommonText(
          text: notification.createdAt?.checkTime ?? '',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        onTap: () {
          controller.readOneNotification(index);
        },
      ),
    );
  }
}
