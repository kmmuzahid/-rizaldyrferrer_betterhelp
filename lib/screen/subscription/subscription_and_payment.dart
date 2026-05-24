/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:better_help/screen/subscription/pages/subscription_inital_page.dart';
import 'package:better_help/screen/subscription/pages/subscription_item.dart';
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
        final subscriptionPlans = controller.subscriptionPlan;
        return Stack(
          children: [
            PageView.builder(
              controller: controller.pageController,
              physics:
                  controller.currentPage.value == 0 &&
                      !controller.routeFromDrawer
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              onPageChanged: (index) {
                controller.currentPage.value = index;
              },
              itemCount:
                  subscriptionPlans.length +
                  (!controller.routeFromDrawer ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && !controller.routeFromDrawer) {
                  return SubscriptionInitalPage(
                    onLearnMore: () {
                      controller.pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  );
                }
                var plan =
                    subscriptionPlans[index -
                        (!controller.routeFromDrawer ? 1 : 0)];
                return SubscriptionItem(
                  plan: plan,
                  isVerifying: controller.isVerifying.value,
                  routeFromDrawer: controller.routeFromDrawer,
                  controller: controller.pageController,
                  index: index,
                  totalSubscription: subscriptionPlans.length,
                  productDetails: controller.storeProducts[plan.productId],
                  duration: controller.getPlanDuration(plan),
                );
              },
            ),
            if (controller.isPurchaseLoading.value)
              Container(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }
}
