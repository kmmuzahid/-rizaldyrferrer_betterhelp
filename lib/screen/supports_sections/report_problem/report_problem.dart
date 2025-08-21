import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';

class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Report Problem",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: [
            Gap(height: 20),
            AppText(
              text:
                  "Please select a time with you better health advocate from these given timeslots",
              color: AppColors.black,
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w600,
              fontFamilyIndex: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              lineHeight: 1.5,
            ),
            Gap(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 30),
                    vertical: AppSize.height(value: 10),
                  ),
                  decoration: BoxDecoration(color: AppColors.primary50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Tues, 23 Feb",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 15),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      Gap(height: 05),
                      AppText(
                        text: "No available slots",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 10),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 30),
                    vertical: AppSize.height(value: 10),
                  ),
                  decoration: BoxDecoration(color: AppColors.primary50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Tues, 23 Feb",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 15),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      Gap(height: 05),
                      AppText(
                        text: "No available slots",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 10),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 30),
                    vertical: AppSize.height(value: 10),
                  ),
                  decoration: BoxDecoration(color: AppColors.primary50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Tues, 23 Feb",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 15),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      Gap(height: 05),
                      AppText(
                        text: "No available slots",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 10),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 30),
                    vertical: AppSize.height(value: 10),
                  ),
                  decoration: BoxDecoration(color: AppColors.primary50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Tues, 23 Feb",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 15),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                      Gap(height: 05),
                      AppText(
                        text: "No available slots",
                        fontFamilyIndex: 3,
                        fontSize: AppSize.width(value: 10),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(height: 15),
            AppText(
              text: "Slots : ",
              fontFamilyIndex: 3,
              fontSize: AppSize.width(value: 15),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            Gap(height: 10),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 30),
                vertical: AppSize.height(value: 10),
              ),
              decoration: BoxDecoration(color: AppColors.primary50),
              child: AppText(
                text: "1:00 PM",
                fontFamilyIndex: 3,
                fontSize: AppSize.width(value: 15),
                fontWeight: FontWeight.w500,
                color: AppColors.primary500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
