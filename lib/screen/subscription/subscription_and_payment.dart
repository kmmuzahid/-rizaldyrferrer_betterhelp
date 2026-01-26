/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/screen/subscription/controller/subscription_and_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionAndPayment extends StatelessWidget {
  const SubscriptionAndPayment({super.key});
  
  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionAndPaymentController());
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        title: Text("Subscription Plans", style: TextStyle(color: Colors.cyan)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final controller = Get.find<SubscriptionAndPaymentController>();
          if (controller.isLoadingDependency.value) {
            return Center(child: CircularProgressIndicator());
          }
          final subscriptionPlans = controller.subscriptionPlans;
          return ListView.builder(
            itemCount: subscriptionPlans.length,
            itemBuilder: (context, index) {
              var plan = subscriptionPlans[index];
              return SubscriptionItem(
                name: plan['name']!,
                price: plan['price']!,
                description: plan['description']!,
                index: index,
              );
            },
          );
        }
        ),
      ),
    );
  }

}


class SubscriptionItem extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final int index;

  const SubscriptionItem({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Subtle background accent
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Color(0xff309AAD),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Popular",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "\$$price",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "/month",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.find<SubscriptionAndPaymentController>().onSubscribe(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEAF5F7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Subscribe Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff309AAD),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
