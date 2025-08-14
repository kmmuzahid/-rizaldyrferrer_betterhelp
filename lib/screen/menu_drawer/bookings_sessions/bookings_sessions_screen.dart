import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_appbar/app_back_appbar.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';

class BookingsSessionsScreen extends StatelessWidget {
  const BookingsSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBack(
        text: "Booked Sessions",
        backgroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          children: [
            Gap(height: 30),
            ...List.generate(10, (index) {
              return Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: AppSize.height(value: 15)),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.27),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 23.16,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppStaticImages.bookingImages,
                          height: AppSize.height(value: 88),
                          width: AppSize.width(value: 93),
                        ),
                        Gap(width: 13),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Dr. Tranquilli',
                              fontSize: 20.85,
                              fontFamilyIndex: 2,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.35,
                            ),
                            Gap(height: 04),
                            AppText(
                              text: 'Bettter Health Advocate',
                              fontSize: 15.06,
                              fontFamilyIndex: 2,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.35,
                              color: Color(0xFF309AAD),
                            ),
                            Gap(height: 03),
                            AppText(
                              text: '2+ Years experience ',
                              color: const Color(0xFF677294),
                              fontSize: 13.90,
                              fontFamilyIndex: 2,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.35,
                            ),
                            Gap(height: 02),
                            AppText(
                              text: '69 Patient Stories',
                              color: const Color(
                                0xFF131927,
                              ) /* Text-Color-text-primary-black */,
                              fontSize: 12,
                              fontFamilyIndex: 2,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.35,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(height: 18),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: AppSize.height(value: 60),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFEAF5F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Upcoming Sessions ',
                                color: const Color(0xFF309AAD),
                                fontSize: 16,
                                fontFamilyIndex: 2,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.35,
                              ),
                              Gap(height: 03),
                              AppText(
                                text: "10:00 AM Tues, 23rd June",
                                fontFamilyIndex: 2,
                                fontSize: AppSize.width(value: 12),
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF677294),
                              ),
                            ],
                          ),
                          AppButton(
                            title: "Set Reminder",
                            titleColor: AppColors.white,
                            fontSize: AppSize.width(value: 14),
                            backgroundColor: AppColors.primary500,
                            height: AppSize.height(value: 36),
                            width: AppSize.width(value: 110),
                            onTap: () {
                              AppSnackBar.message(
                                "This Feature will implemented sooned",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
