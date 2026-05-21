import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/before_question_screen/controller/before_question_screen_controller.dart';
import 'package:better_help/screen/before_question_screen/widget/policy_agreement_widget.dart';
import 'package:better_help/screen/questionnaries_screen/controller/questionnaries_screen_controller.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors/app_colors.dart';
import '../../utils/app_images/app_images.dart';
import '../../utils/app_string/app_string.dart';
import '../../widget/app_button/app_button.dart';
import '../../widget/app_text/app_text.dart';

class BeforeQuestionScreen extends StatelessWidget {
  BeforeQuestionScreen({super.key});

  final controller = Get.put(BeforeQuestionScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppStaticImages.onboarding_background_01,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(height: AppSize.height(value: 35)),
                    Padding(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Gap(height: AppSize.height(value: 85)),
                          Center(
                            child: Image.asset(
                              AppStaticImages.beforeQuestionImage,
                            ),
                          ),
                          Gap(height: AppSize.height(value: 40)),
                          CommonText(
                            text: AppString.weHavegotYourAttention,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.grey500,
                            style: const TextStyle(
                              fontFamily: 'PlayfairDisplay',
                            ),
                          ),

                          Gap(height: AppSize.height(value: 8)),

                          CommonText(
                            text: AppString.weHaveGotYourAttentionDetails,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.white900,
                            style: const TextStyle(fontFamily: 'inter'),
                            maxLines: 4,
                            textAlign: TextAlign.center,
                            isDescription: true,
                          ),

                          Gap(height: AppSize.height(value: 40)),

                          AppButton(
                            title: AppString.begin,
                            onTap: () {
                              // Delete any existing questionnaire controller before navigating
                              Get.dialog(
                                PolicyAgreementWidget(
                                  onAgree: () {
                                    Get.delete<
                                      QuestionnariesScreenController
                                    >();
                                    Get.back();
                                    Get.toNamed(AppRoute.questionariescreen);
                                  },
                                ),
                              );
                            },
                            backgroundColor: AppColors.primary500,
                            height: AppSize.height(value: 48),
                          ),

                          Gap(height: AppSize.height(value: 40)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              AppText(
                                text: AppString.alreaHaveanAccount,
                                fontSize: AppSize.width(value: 14),
                                fontWeight: FontWeight.w400,
                                color: AppColors.white900,
                                maxLines: 4,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoute.loginScreen);
                                },
                                child: AppText(
                                  text: 'Sign In',
                                  fontSize: AppSize.width(value: 12),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary900,
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              20.width,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
