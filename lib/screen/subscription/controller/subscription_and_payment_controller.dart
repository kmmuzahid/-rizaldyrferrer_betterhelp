/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/notification/notification_screen_controller.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class SubscriptionAndPaymentController extends GetxController {
  var isLoadingDependency = true.obs;
  final List<Map<String, String>> subscriptionPlans = [
    {
      "name": "Free",
      "price": "0",
      "description":
          "Access basic health consultation services. Get expert advice from certified doctors with limited features. Perfect for general health inquiries.",
    },
    {
      "name": "Ascend",
      "price": "10",
      "description":
          "Gain access to enhanced consultations with quicker response times. Includes detailed follow-ups, basic prescriptions, and limited access to health tracking.",
    },
    {
      "name": "Elevate",
      "price": "20",
      "description":
          "Upgrade to premium services with priority booking, extended consultation times, advanced prescriptions, and access to specialized healthcare professionals.",
    },
    {
      "name": "Accelerate",
      "price": "35",
      "description":
          "For those seeking fast-track healthcare services. Includes real-time chat with doctors, personalized treatment plans, access to health reports, and priority support.",
    },
    {
      "name": "Ignite",
      "price": "50",
      "description":
          "The most comprehensive plan. Includes unlimited consultations, access to top-tier specialists, personalized health coaching, advanced diagnostics, and immediate medical support, anytime.",
    },
  ].obs;

  onSubscribe(int index) async {
    final response = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(endpoint: AppApiurl.createSubscription, method: RequestMethod.POST),
      responseBuilder: (data) {
        return data;
      },
    );

    if (response.isSuccess) {
      return Get.toNamed(AppRoute.bottomNav);
    }
  }

  @override
  void onInit() async {
    SocketService.instance.connect();
    isLoadingDependency.value = true;
    final profileController = Get.find<MyProfileScreenController>();
    profileController.fetchProfile().then((value) {
      if (profileController.profileData.value?.isSubscribed == true) {
        return Get.toNamed(AppRoute.bottomNav);
      }
      isLoadingDependency.value = false;
    });
    Get.find<NotificationScreenController>()
      ..getUnreadCount()
      ..listenNotification();

    super.onInit();
  }
}
