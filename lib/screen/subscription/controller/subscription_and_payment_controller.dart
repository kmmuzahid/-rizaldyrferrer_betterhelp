/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/subscription/model/subscription_model.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionAndPaymentController extends GetxController {
  var isLoadingDependency = true.obs;
  late PageController pageController;
  final RxList<SubscriptionModel> subscriptionPlan =
      RxList<SubscriptionModel>();

  onSubscribe(int index) async {
    final response = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.createSubscription,
        method: RequestMethod.POST,
      ),
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
    pageController = PageController();

    final response = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.package,
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) {
        return List<SubscriptionModel>.from(
          data.map((x) => SubscriptionModel.fromJson(x)),
        );
      },
    );

    if (response.isSuccess) {
      subscriptionPlan.value = response.data ?? [];
      print(response.data!.first.buttonColor);
      print(response.data!.first.buttonTextColor);
    }

    SocketService.instance.connect();
    isLoadingDependency.value = true;
    final profileController = Get.find<MyProfileScreenController>();
    profileController.fetchProfile().then((value) {
      if (profileController.profileData.value?.isSubscribed == true) {}
      // return Get.toNamed(AppRoute.bottomNav);
      isLoadingDependency.value = false;
    });
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
