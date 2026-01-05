import 'package:better_help/screen/no_internet_screen/controller/no_internet_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_route/app_route.dart';
import '../../widget/app_button/app_button.dart';
import '../../widget/app_text/app_text.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder(
      init: NoInternetScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Icon(
                    controller.isInternetProblem.value
                        ? Icons.signal_wifi_off_outlined
                        : Icons.error_outline_rounded,
                    size: 100,
                  ),
                ),
                Gap(height: AppSize.height(value: 20),),
                Obx(() => AppText(text: controller.errorMessage.value)),
                Obx(
                  () => controller.isInternetProblem.value
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: const AppText(
                            text: "Check your internet connection",
                          ),
                        )
                      : const SizedBox(),
                ),
                Gap(height: AppSize.height(value: 30),),

                AppButton(
                  title: "Try again",
                  onTap: () async {
                    await Get.offAllNamed(AppRoute.splashscreen);
                  },
                  height: 55,
                  titleColor: AppColors.white,
                  width: 150,
                  backgroundColor: AppColors.primary500,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}