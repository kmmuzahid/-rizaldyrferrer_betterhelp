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
  const AppBarWithBack({super.key, required this.text, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: backgroundColor ?? AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 05, top: 04, bottom: 05),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 05),
                vertical: AppSize.height(value: 05),
              ),
              decoration: BoxDecoration(
                color: AppColors.t3,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: SvgPicture.asset(AppIcons.appBackUptton)),
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
