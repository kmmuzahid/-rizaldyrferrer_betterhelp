import 'package:better_help/screen/questionnaries_screen/controller/questionnaries_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/add_custom_question_container/custom_question_container.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class QuestionnariesScreen extends StatelessWidget {
  const QuestionnariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionnariesScreenController());
    return Obx(
      () => Scaffold(
        backgroundColor: getBackgroundColors(controller.currentPageIndex.value),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 12)),
            child: Column(
              children: [
                Gap(height: AppSize.height(value: 10)),
                Row(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppIcons.questionPageBack,
                        height: AppSize.height(value: 24),
                        width: AppSize.width(value: 24),
                      ),
                    ),
                    Gap(width: AppSize.width(value: 08)),
                    Flexible(
                      child: AppText(
                        text: AppString.questionTitle,
                        color: AppColors.white500,
                        lineHeight: 1.3,
                        fontSize: AppSize.width(value: 16),
                        fontFamilyIndex: 2,
                        fontWeight: FontWeight.w600,
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gap(height: AppSize.height(value: 26)),
                //! Questionnaries Step
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 12),
                    vertical: AppSize.height(value: 9),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSize.width(value: 12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Obx(
                        () => AppText(
                          text:
                              "${AppString.step} ${controller.getCurrentStepText()}",
                          fontSize: AppSize.width(value: 12),
                          fontFamilyIndex: 4,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          return SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: AppSize.height(value: 6),
                              activeTrackColor:
                                  AppColors.questionBG01StatusBarColor,
                              inactiveTickMarkColor: AppColors
                                  .questionBG01StatusBarColor
                                  .withValues(alpha: 0.3),
                            ),
                            child: Slider(
                              value: controller.progressValue.value,
                              onChanged: (value) {
                                // Disabled - progress is controlled by questions
                              },
                              max: 4,
                              min: 1,
                              activeColor: _getActiveSliderColor(
                                controller.currentPageIndex.value,
                              ),
                              inactiveColor: _getInactiveSliderColor(
                                controller.currentPageIndex.value,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Gap(height: AppSize.height(value: 18)),
                // PageView
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      SingleChildScrollView(child: questionPage01(controller)),
                      SingleChildScrollView(child: questionPage02(controller)),
                      SingleChildScrollView(child: questionPage03(controller)),
                      SingleChildScrollView(child: questionPage04(controller)),
                      questionPage05(controller),
                    ],
                  ),
                ),
                Gap(height: AppSize.height(value: 20)),
                Obx(
                  () => AppButton(
                    title:
                        controller.currentPageIndex.value ==
                            controller.totalPages - 1
                        ? 'Complete'
                        : AppString.next,
                    titleColor: AppColors.black,
                    backgroundColor: AppColors.white,
                    onTap: controller.nextPage,
                  ),
                ),
                Gap(height: AppSize.height(value: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget questionPage01(QuestionnariesScreenController controller) => Column(
  children: [
    Gap(height: AppSize.height(value: 18)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle01,
      questionText: AppString.question1,
      questionNumber: 1,
      totalQuestions: 15,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle01,
      questionText: AppString.question2,
      questionNumber: 2,
      totalQuestions: 15,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle01,
      questionText: AppString.question3,
      questionNumber: 3,
      totalQuestions: 15,
    ),
    Gap(height: AppSize.height(value: 70)),
  ],
);

Widget questionPage02(QuestionnariesScreenController controller) => Column(
  children: [
    Gap(height: AppSize.height(value: 18)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle02,
      questionText: AppString.question4,
      questionNumber: 4,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG02,
      selectedAnswerColor: AppColors.questionBG02,
      answerCardBg: AppColors.questionBg02CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle02,
      questionText: AppString.question5,
      questionNumber: 5,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG02,
      selectedAnswerColor: AppColors.questionBG02,
      answerCardBg: AppColors.questionBg02CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle02,
      questionText: AppString.question6,
      questionNumber: 6,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG02,
      selectedAnswerColor: AppColors.questionBG02,
      answerCardBg: AppColors.questionBg02CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 70)),
  ],
);
Widget questionPage03(QuestionnariesScreenController controller) => Column(
  children: [
    Gap(height: AppSize.height(value: 18)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle03,
      questionText: AppString.question7,
      questionNumber: 7,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG03,
      selectedAnswerColor: AppColors.questionBG03,
      answerCardBg: AppColors.questionBg03CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle03,
      questionText: AppString.question8,
      questionNumber: 8,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG03,
      selectedAnswerColor: AppColors.questionBG03,
      answerCardBg: AppColors.questionBg03CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle03,
      questionText: AppString.question9,
      questionNumber: 9,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG03,
      selectedAnswerColor: AppColors.questionBG03,
      answerCardBg: AppColors.questionBg03CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 70)),
  ],
);
Widget questionPage04(QuestionnariesScreenController controller) => Column(
  children: [
    Gap(height: AppSize.height(value: 18)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle04,
      questionText: AppString.question10,
      questionNumber: 10,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG04,
      selectedAnswerColor: AppColors.questionBG04,
      answerCardBg: AppColors.questionBg04CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle04,
      questionText: AppString.question11,
      questionNumber: 11,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG04,
      selectedAnswerColor: AppColors.questionBG04,
      answerCardBg: AppColors.questionBg04CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 12)),
    CustomQuestionContainer(
      controller: controller,
      questionImage: AppStaticImages.qusDoddle04,
      questionText: AppString.question12,
      questionNumber: 12,
      totalQuestions: 15,
      badgeBackgroundColor: AppColors.questionBG04,
      selectedAnswerColor: AppColors.questionBG04,
      answerCardBg: AppColors.questionBg04CardOptionBg,
    ),
    Gap(height: AppSize.height(value: 40)),
  ],
);

Widget questionPage05(QuestionnariesScreenController controller) {
  List<String> selectPageOption = [
    AppString.buildingBetterHabits,
    AppString.boostingProductivity,
    AppString.stayingActiveandEngergized,
    AppString.sharperningFocus,
    AppString.strengtheingDiscipline,
    AppString.livingMoreMidfully,
    AppString.mangingTimeBetter,
    AppString.mangingTimeBetter,
    AppString.reducingOverwhelm,
    AppString.followingThoughonGoals,
    AppString.feelingEmotionallyBalanced,
    AppString.improvingSelfawreness,
    AppString.improvingSelfawreness,
    AppString.creatingAhealthierRoutine,
  ];

  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 12),
          vertical: AppSize.height(value: 9),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.width(value: 12)),
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              AppStaticImages.qusDoddle05,
              height: AppSize.height(value: 115),
              width: AppSize.width(value: 115),
            ),
            Gap(height: AppSize.height(value: 14)),
            AppText(
              text: AppString.whatdoYouwanttoAchieve,
              fontSize: AppSize.width(value: 16),
              fontFamilyIndex: 5,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            Gap(height: AppSize.height(value: 14)),
            ...List.generate(selectPageOption.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSize.height(value: 8)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 18),
                    vertical: AppSize.height(value: 8),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSize.width(value: 12)),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Toggle selection logic here
                        },
                        child: Icon(
                          Icons.circle,
                          color: false ? Colors.red : Colors.grey,
                          size: AppSize.width(value: 20),
                        ),
                      ),
                      Gap(width: AppSize.width(value: 12)),
                      Expanded(
                        child: AppText(
                          text: selectPageOption[index],
                          fontSize: AppSize.width(value: 14),
                          fontFamilyIndex: 4,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ],
  );
}

// Helper functions for slider colors
Color _getActiveSliderColor(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return AppColors.questionBG01StatusBarColor;
    case 1:
      return AppColors.questionBG02StatusBarColor;
    case 2:
      return AppColors.questionBG03StatusBarColor;
    case 3:
      return AppColors.questionBG04StatusBarColor;

    default:
      return AppColors.questionBG01StatusBarColor;
  }
}

Color getBackgroundColors(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return AppColors.questionBG01;
    case 1:
      return AppColors.questionBG02;
    case 2:
      return AppColors.questionBG03;
    case 3:
      return AppColors.questionBG04;
    case 4:
      return AppColors.questionBG05;
    default:
      return AppColors.questionBG01;
  }
}

Color _getInactiveSliderColor(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return AppColors.questionBG01StatusBarColor.withValues(alpha: 0.3);
    case 1:
      return AppColors.questionBG02StatusBarColor.withValues(alpha: 0.3);
    case 2:
      return AppColors.questionBG03StatusBarColor.withValues(alpha: 0.3);
    case 3:
      return AppColors.questionBG04StatusBarColor.withValues(alpha: 0.3);
    default:
      return AppColors.questionBG01StatusBarColor.withValues(alpha: 0.3);
  }
}
