import 'package:better_help/core/app_route/app_route.dart';
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
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class QuestionnariesScreen extends StatelessWidget {
  const QuestionnariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(
    //   QuestionnariesScreenController(),
    //   tag: 'questionnaires',
    // );
    final controller = Get.find<QuestionnariesScreenController>(tag: 'questionnaires');

    return Obx(
      () => Scaffold(
        backgroundColor: _getBackgroundColor(controller.currentPageIndex.value),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 12)),
            child: Column(
              children: [
                if (!controller.isResultPage) ...[
                  _buildHeader(controller, context),
                ] else ...[
                  Gap(height: AppSize.height(value: 20)),
                ],
                _buildPageView(controller),
                Gap(height: AppSize.height(value: 20)),
                _buildBottomButton(controller),
                Gap(height: AppSize.height(value: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(QuestionnariesScreenController controller, BuildContext context) {
    return Column(
      children: [
        Gap(height: AppSize.height(value: 32)),
        Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: controller.previousPage,
              child: SvgPicture.asset(
                AppIcons.questionPageBack,
                height: AppSize.height(value: 24),
                width: AppSize.width(value: 24),
              ),
            ),
            Gap(width: AppSize.width(value: 8)),
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
        _buildProgressIndicator(controller, context),
        Gap(height: AppSize.height(value: 18)),
      ],
    );
  }

  Widget _buildProgressIndicator(QuestionnariesScreenController controller, BuildContext context) {
    final pageIndex = controller.currentPageIndex.value;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(value: 12),
        vertical: AppSize.height(value: 9),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
      ),
      child: Row(
        children: [
          Obx(
            () => AppText(
              text: "${AppString.step} ${controller.getCurrentStepText()}",
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
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                ),
                child: Slider(
                  value: controller.progressValue.value,
                  onChanged: (_) {},
                  max: (QuestionnariesScreenController.totalPages - 1).toDouble(),
                  min: 1,
                  activeColor: _getActiveSliderColor(pageIndex),
                  inactiveColor: _getInactiveSliderColor(pageIndex),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(QuestionnariesScreenController controller) {
    return Expanded(
      child: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(child: _buildQuestionPage(controller, 0)),
          SingleChildScrollView(child: _buildQuestionPage(controller, 1)),
          SingleChildScrollView(child: _buildQuestionPage(controller, 2)),
          SingleChildScrollView(child: _buildGoalsPage(controller)),
          SingleChildScrollView(child: _buildResultPage()),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(QuestionnariesScreenController controller, int pageIndex) {
    final questions = controller.questionsByPage[pageIndex];
    final pageConfig = _getPageConfig(pageIndex);
    final startQuestionNumber = pageIndex * QuestionnariesScreenController.questionsPerPage + 1;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Image.asset(
            _getQuestionImage(pageIndex),
            height: AppSize.height(value: 200),
            width: AppSize.width(value: 200),
          ),

          Gap(height: AppSize.height(value: 18)),
          ...List.generate(questions.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSize.height(value: 12)),
              child: CustomQuestionContainer(
                controller: controller,
                questionText: questions[index],
                questionNumber: startQuestionNumber + index,
                selectedAnswerColor: pageConfig.selectedColor,
                answerCardBg: pageConfig.cardBgColor,
              ),
            );
          }),
          Gap(height: AppSize.height(value: 18)),
        ],
      ),
    );
  }

  String _getQuestionImage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return AppStaticImages.qusDoddle01;
      case 1:
        return AppStaticImages.qusDoddle02;
      case 2:
        return AppStaticImages.qusDoddle03;
      default:
        return AppStaticImages.qusDoddle01;
    }
  }

  Widget _buildResultPage() {
    final controller = Get.find<QuestionnariesScreenController>(tag: 'questionnaires');

    return Column(
      children: [
        // Center(
        //   child: AppText(
        //     text: AppString.youCrusedIt,
        //     fontWeight: FontWeight.w600,
        //     fontSize: AppSize.width(value: 24),
        //     color: AppColors.black,
        //     fontFamilyIndex: 2,
        //   ),
        // ),
        // Gap(height: AppSize.height(value: 08)),
        // Center(
        //   child: AppText(
        //     text: AppString.youAreCloser,
        //     color: AppColors.black,
        //     fontFamilyIndex: 2,
        //     fontSize: AppSize.width(value: 16),
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        Gap(height: AppSize.height(value: 50)),
        Image.asset(
          AppStaticImages.resultImage,
          height: AppSize.height(value: 250),
          width: AppSize.width(value: 250),
        ),
        Gap(height: AppSize.height(value: 11)),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(value: 24),
            horizontal: AppSize.width(value: 16),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.width(value: 08)),
          ),
          child: Column(
            children: [
              Center(
                child: AppText(
                  text: "Scale of 1-10",
                  fontFamilyIndex: 2,
                  fontSize: AppSize.width(value: 24),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              4.height,
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "If",
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: " 1 represents struggling",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: " and",
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      TextSpan(
                        text: " 10 represents thriving",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),

                      TextSpan(
                        text: ", how would you rate your overall wellbeing?",
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: AppSize.width(value: 16),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(height: AppSize.height(value: 16)),
              _buildScaleSelector(controller),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScaleSelector(QuestionnariesScreenController controller) {
    return Obx(
      () => Column(
        children: [
          // First row: 1-5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final number = index + 1;
              final isSelected = controller.isScaleNumberSelected(number);
              return GestureDetector(
                onTap: () => controller.selectScaleNumber(number),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 14),
                    vertical: AppSize.height(value: 8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.redAccent : AppColors.resultBg,
                    borderRadius: BorderRadius.circular(AppSize.width(value: 06)),
                  ),
                  child: AppText(
                    text: "$number",
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontSize: AppSize.width(value: 20),
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    fontFamilyIndex: 2,
                  ),
                ),
              );
            }),
          ),
          Gap(height: AppSize.height(value: 12)),
          // Second row: 6-10
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final number = index + 6;
              final isSelected = controller.isScaleNumberSelected(number);
              return GestureDetector(
                onTap: () => controller.selectScaleNumber(number),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(value: 14),
                    vertical: AppSize.height(value: 8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.redAccent : AppColors.resultBg,
                    borderRadius: BorderRadius.circular(AppSize.width(value: 06)),
                  ),
                  child: AppText(
                    text: "$number",
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontSize: AppSize.width(value: 20),
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    fontFamilyIndex: 2,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(QuestionnariesScreenController controller) {
    return Obx(() {
      final isResult = controller.isResultPage;
      final isGoals = controller.isGoalsPage;
      final isLoading = controller.isLoading.value;

      return AppButton(
        title: (isResult ? 'Submit' : (isGoals ? 'Continue' : AppString.next)),
        titleColor: isResult ? AppColors.white : AppColors.black,
        backgroundColor: isResult ? Colors.red : AppColors.white,
        onTap: isLoading
            ? null
            : (isResult
                  ? () {
                      controller.completeQuestionnaire();
                      Get.toNamed(AppRoute.analyzeScreen);
                    }
                  : controller.nextPage),
      );
    });
  }

  Widget _buildGoalsPage(QuestionnariesScreenController controller) {
    return Obx(
      () => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 12),
              vertical: AppSize.height(value: 9),
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
            ),
            child: Column(
              children: [
                Image.asset(
                  AppStaticImages.goalPageImage,
                  height: AppSize.height(value: 115),
                  width: AppSize.width(value: 115),
                ),
                Gap(height: AppSize.height(value: 14)),
                AppText(
                  text: AppString.whatdoYouwanttoAchieve,
                  fontSize: 20.sp,
                  fontFamilyIndex: 5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  textAlign: TextAlign.center,
                ),
                Gap(height: AppSize.height(value: 14)),
                ...List.generate(controller.goalOptions.length, (index) {
                  final isSelected = controller.isGoalSelected(index);
                  return GestureDetector(
                    onTap: () => controller.toggleGoal(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(value: 18),
                        vertical: AppSize.height(value: 8),
                      ),
                      margin: EdgeInsets.only(bottom: AppSize.height(value: 8)),
                      height: AppSize.height(value: 44),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.questionBG05.withValues(alpha: 0.08)
                            : AppColors.blue50,
                        borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isSelected ? AppColors.questionBG05 : AppColors.white900,
                            size: AppSize.width(value: 20),
                          ),
                          Gap(width: AppSize.width(value: 12)),
                          AppText(
                            text: controller.goalOptions[index],
                            fontSize: AppSize.width(value: 14),
                            fontFamilyIndex: 4,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.questionBG05 : AppColors.grey500,
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
      ),
    );
  }
}

// Page configuration model
class _PageConfig {
  final Color selectedColor;
  final Color cardBgColor;

  const _PageConfig({required this.selectedColor, required this.cardBgColor});
}

_PageConfig _getPageConfig(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return const _PageConfig(
        selectedColor: AppColors.questionBG01,
        cardBgColor: AppColors.answerCardBgColor,
      );
    case 1:
      return const _PageConfig(
        selectedColor: AppColors.questionBG02,
        cardBgColor: AppColors.answerCardBgColor,
      );
    case 2:
      return const _PageConfig(
        selectedColor: AppColors.questionBG03,
        cardBgColor: AppColors.answerCardBgColor,
      );
    default:
      return const _PageConfig(
        selectedColor: AppColors.questionBG01,
        cardBgColor: AppColors.answerCardBgColor,
      );
  }
}

Color _getBackgroundColor(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return AppColors.questionBG01;
    case 1:
      return AppColors.questionBG02;
    case 2:
      return AppColors.questionBG03;
    case 3:
      return AppColors.questionBG05;
    case 4:
      return AppColors.resultBg;
    default:
      return AppColors.questionBG01;
  }
}

Color _getActiveSliderColor(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return AppColors.questionBG01StatusBarColor;
    case 1:
      return AppColors.questionBG02StatusBarColor;
    case 2:
      return AppColors.questionBG03StatusBarColor;
    case 3:
      return AppColors.questionBG05StatusBarColor;
    case 4:
      return AppColors.questionBG05StatusBarColor;
    default:
      return AppColors.questionBG01StatusBarColor;
  }
}

Color _getInactiveSliderColor(int pageIndex) {
  return _getActiveSliderColor(pageIndex).withValues(alpha: 0.3);
}
