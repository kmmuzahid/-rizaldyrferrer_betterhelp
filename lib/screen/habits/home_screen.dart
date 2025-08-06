import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        leadingWidth: AppSize.width(value: 50),
        leading: CircleAvatar(
          radius: 100,
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              AppStaticImages.habitsAppbar,
              height: AppSize.height(value: 48),
              width: AppSize.width(value: 48),
            ),
          ),
        ),
        titleSpacing: -3,
        title: Column(
          children: [
            AppText(
              text: AppString.getReadytoStart,
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            Gap(height: 10),
            AppText(
              text: AppString.mahbubulQareem,
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 14),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              AppIcons.notificationIcons,
              height: AppSize.height(value: 18),
              width: AppSize.width(value: 18),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              AppIcons.menuIcons,
              height: AppSize.height(value: 24),
              width: AppSize.width(value: 18),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.ocean500,
      body: Center(
        child: Text(
          "Home Screen",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
