import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/notification/model/notification_model.dart';
import 'package:better_help/screen/notification/notification_service.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:get/get.dart';

class NotificationScreenController extends GetxController {
  var unreadCount = 0.obs;
  var notificationList = <NotificationModel>[].obs;
  var isLoading = false.obs;
  final MyProfileScreenController profileController =
      Get.find<MyProfileScreenController>();

  void listenNotification() {
    SocketService.instance.startListeningNotification(
      onNotification: (data) {
        final notification = NotificationModel.fromJson(data);
        // if (notification.userId == profileController.profileData.value?.id) return;
        addSingleNotification(notification);
        if (Get.currentRoute != AppRoute.notificationScreen) {
          NotificationService.instance.showNotification(
            title: notification.message,
          );
        }
      },
    );
  }

  Future<void> addSingleNotification(NotificationModel notification) async {
    notificationList.insert(0, notification);
    unreadCount.value++;
  }

  Future<void> getUnreadCount() async {
    final response = await CkTransport.request<int>(
      input: RequestInput(
        endpoint: ApiEndPoints.notification,
        queryParams: {'limit': 1},
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return data['unReadCount']?.toInt() ?? 0;
      },
    );
    unreadCount.value = response.data ?? 0;
  }

  Future<void> getAllNotification({
    int page = 1,
    bool isRefresh = false,
  }) async {
    isLoading.value = true;
    final response = await CkTransport.request<List<NotificationModel>>(
      input: RequestInput(
        endpoint: ApiEndPoints.notification,
        queryParams: {'page': page, 'limit': 20},
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return List<NotificationModel>.from(
          data['result'].map((x) => NotificationModel.fromJson(x)),
        );
      },
    );
    if (isRefresh) {
      notificationList.value = response.data ?? [];
    } else {
      notificationList.addAll(response.data ?? []);
    }
    isLoading.value = false;
  }

  Future<void> markAllRead() async {
    final response = await CkTransport.request<dynamic>(
      input: RequestInput(
        endpoint: ApiEndPoints.notificationAllRead,
        method: RequestMethod.POST,
      ),
      responseBuilder: (data) {
        return data;
      },
    );
    if (response.isSuccess) {
      unreadCount.value = 0;
      for (int i = 0; i < notificationList.length; i++) {
        notificationList[i] = notificationList[i].copyWith(isRead: true);
      }
      notificationList.refresh();
    }
  }

  Future<void> readOneNotification(int index) async {
    final notification = notificationList[index];
    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.getNotificationRead(notification.id),
        method: RequestMethod.PATCH,
      ),
      responseBuilder: (data) {
        return data;
      },
    );
    if (response.isSuccess) {
      unreadCount.value--;
      notificationList[index] = notification.copyWith(isRead: true);
      notificationList.refresh();
    }
  }
}
