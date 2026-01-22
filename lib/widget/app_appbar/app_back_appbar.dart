/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final Color? backgroundColor;
  final List<Widget>? actions;
  const AppBarWithBack({super.key, required this.text, this.backgroundColor, this.actions});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: backgroundColor ?? AppColors.white,
        automaticallyImplyLeading: false,
        actions: actions,
        leading: Container(
          margin: EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: AppSize.height(value: 10),
              decoration: BoxDecoration(
                color: AppColors.t3,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.appBackUptton,
                  height: 10,
                  width: 10,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: AppText(
          text: text,
          fontFamilyIndex: 2,
          fontSize: AppSize.width(value: 18),
          fontWeight: FontWeight.w500,
          color: AppColors.grey500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
