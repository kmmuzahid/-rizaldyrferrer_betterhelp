/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:better_help/screen/subscription/pages/subscription_inital_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionAndPayment extends StatelessWidget {
  const SubscriptionAndPayment({super.key});
  
  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionAndPaymentController());
    return Scaffold(
      
      body: Obx(() {
        final controller = Get.find<SubscriptionAndPaymentController>();
        if (controller.isLoadingDependency.value) {
          return Center(child: CircularProgressIndicator());
        }
        final subscriptionPlans = controller.subscriptionPlans;
        return PageView.builder(
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subscriptionPlans.length + 1,
          itemBuilder: (context, index) {
            var plan = subscriptionPlans[index];
            if (index == 0) {
              return SubscriptionInitalPage();
            }
            return Container();
          },
        );
      }),
    );
  }

}

