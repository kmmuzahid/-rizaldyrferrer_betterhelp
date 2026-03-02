/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/subscription/model/subscription_plan.dart';
import 'package:better_help/sockets/support_message_socket.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionAndPaymentController extends GetxController {
  var isLoadingDependency = true.obs;
  late PageController pageController;
  final RxList<SubscriptionPlan> subscriptionPlan = RxList<SubscriptionPlan>();

  onSubscribe(int index) async { 
    final response = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(endpoint: ApiEndPoints.createSubscription, method: RequestMethod.POST),
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

    for (int i = 0; i < 3; i++) {
      subscriptionPlan.add(
        SubscriptionPlan(
          title: 'Ignite Plan $i',
          subtitle: 'First 14 days free= Then \$69/Month',
          image: AppStaticImages.subscription01,
          backgroundColor: Color.fromARGB(255, 206, 231, 225 + i * 10),
          featureList: [
            'Initial consultation with an expert Advocate',
            'Monthly progress report',
            'Daily check-ins and reminders from your  Advocate Assistant',
            'Guided courses and resources',
            'Private forum + live Q&A sessions',
            'Milestones & recognition to celebrate your growth',
          ],
          buttonColor: AppColors.blue800,
          buttonTextColor: Colors.white,
          applePrdocutId: '1',
          googleProductId: '1',
        ),
      );
    }

    SocketService.instance.connect();
    isLoadingDependency.value = true;
    final profileController = Get.find<MyProfileScreenController>();
    profileController.fetchProfile().then((value) {
      if (profileController.profileData.value?.isSubscribed == true) {
        return Get.toNamed(AppRoute.bottomNav);
      }
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
