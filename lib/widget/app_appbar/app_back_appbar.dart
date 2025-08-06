import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWithBack extends StatelessWidget {
  final String text;
  const AppBarWithBack({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: AppSize.height(value: 36),
              width: AppSize.width(value: 36),
              decoration: BoxDecoration(
                color: AppColors.t3,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(AppIcons.appBarbackbutton),
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
}
