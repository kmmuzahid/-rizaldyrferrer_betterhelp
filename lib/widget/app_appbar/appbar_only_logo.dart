/*
 * @Author: Km Muzahid
 * @Date: 2026-03-01 14:12:01
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppBarOnlyLogo extends StatelessWidget {
  const AppBarOnlyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(AppIcons.appbarBackIcon),
          ),
          Gap(width: AppSize.width(value: 60)),
          Image.asset(
            AppStaticImages.appBarlogo,
            height: AppSize.height(value: 65),
            width: AppSize.width(value: 174),
          ),
        ],
      ),
    );
  }
}
