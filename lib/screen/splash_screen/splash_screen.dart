import 'package:better_help/screen/splash_screen/controller/splash_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    Size size = MediaQuery.of(context).size;
    AppSize.size = size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(
          AppStaticImages.appLogo,
          height: AppSize.height(value: 430),
          width: AppSize.width(value: 430),
        ),
      ),
    );
  }
}
