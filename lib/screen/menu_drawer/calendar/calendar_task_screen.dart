import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';

class CalendarTaskScreen extends StatelessWidget {
  const CalendarTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Calendar",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: [
            Center(child: AppText(text: "This the Calendar Task Screen")),
          ],
        ),
      ),
    );
  }
}
