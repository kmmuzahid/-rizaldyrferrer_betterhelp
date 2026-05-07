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
import 'package:get/get.dart';

class QuestionnariesScreen extends StatelessWidget {
  const QuestionnariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(
    //   QuestionnariesScreenController(),
    //   tag: 'questionnaires',
    // );
    final controller = Get.find<QuestionnariesScreenController>(
      tag: 'questionnaires',
    );

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

  Widget _buildHeader(
    QuestionnariesScreenController controller,
    BuildContext context,
  ) {
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

  Widget _buildProgressIndicator(
    QuestionnariesScreenController controller,
    BuildContext context,
  ) {
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
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 0,
                  ),
                ),
                child: Slider(
                  value: controller.progressValue.value,
                  onChanged: (_) {},
                  max: (QuestionnariesScreenController.totalPages - 1)
                      .toDouble(),
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

  Widget _buildQuestionPage(
    QuestionnariesScreenController controller,
    int pageIndex,
  ) {
    final questions = controller.questionsByPage[pageIndex];
    final pageConfig = _getPageConfig(pageIndex);
    final startQuestionNumber =
        pageIndex * QuestionnariesScreenController.questionsPerPage + 1;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
    final controller = Get.find<QuestionnariesScreenController>(
      tag: 'questionnaires',
    );

    return Column(
      children: [
        Gap(height: AppSize.height(value: 60)),
        Image.asset(
          AppStaticImages.resultImage,
          height: AppSize.height(value: 230),
          width: AppSize.width(value: 230),
        ),
        Gap(height: AppSize.height(value: 15)),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.height(value: 30),
            horizontal: AppSize.width(value: 20),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.width(value: 16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
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
              Gap(height: AppSize.height(value: 20)),
              _questions(
                controller: controller,
                boldText: "10 represents thriving",
                endText: ", how would you rate your overall wellbeing in life?",
                isSelected:
                    (number) => controller.isScaleWellbeingSelected(number),
                onSelect: (number) => controller.selectScaleWellbeing(number),
              ),
              Gap(height: AppSize.height(value: 30)),
              _questions(
                controller: controller,
                boldText: "10 means feeling productive",
                endText:
                    " in the ways that matter to you, where would you rate yourself today?",
                isSelected:
                    (number) => controller.isScaleProductivitySelected(number),
                onSelect: (number) => controller.selectScaleProductivity(number),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _questions({
    required QuestionnariesScreenController controller,
    required String boldText,
    required String endText,
    required bool Function(int) isSelected,
    required void Function(int) onSelect,
  }) {
    return Column(
      children: [
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "If ",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: boldText,
                  style: TextStyle(
                    color: AppColors.textPrimaryBlack,
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                TextSpan(
                  text: endText,
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(height: AppSize.height(value: 12)),
        _buildScaleSelector(isSelected: isSelected, onSelect: onSelect),
      ],
    );
  }

  Widget _buildScaleSelector({
    required bool Function(int) isSelected,
    required void Function(int) onSelect,
  }) {
    return Obx(
      () => Column(
        children: [
          // First row: 1-5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final number = index + 1;
              final selected = isSelected(number);
              return GestureDetector(
                onTap: () => onSelect(number),
                child: Container(
                  width: AppSize.width(value: 60),
                  height: AppSize.height(value: 45),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.red500 : AppColors.ratingBg,
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 08),
                    ),
                  ),
                  child: AppText(
                    text: "$number",
                    color: selected ? AppColors.white : AppColors.textPrimaryBlack,
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
              final selected = isSelected(number);
              return GestureDetector(
                onTap: () => onSelect(number),
                child: Container(
                  width: AppSize.width(value: 60),
                  height: AppSize.height(value: 45),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.red500 : AppColors.ratingBg,
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 08),
                    ),
                  ),
                  child: AppText(
                    text: "$number",
                    color: selected ? AppColors.white : AppColors.textPrimaryBlack,
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
        height: AppSize.height(value: 52),
        borderradius: AppSize.width(value: 10),
        title: (isResult ? 'Submit' : (isGoals ? 'Continue' : AppString.next)),
        titleColor: AppColors.white,
        backgroundColor: isResult ? AppColors.red500 : AppColors.blue500,
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
                        borderRadius: BorderRadius.circular(
                          AppSize.width(value: 12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isSelected
                                ? AppColors.questionBG05
                                : AppColors.white900,
                            size: AppSize.width(value: 20),
                          ),
                          Gap(width: AppSize.width(value: 12)),
                          AppText(
                            text: controller.goalOptions[index],
                            fontSize: AppSize.width(value: 14),
                            fontFamilyIndex: 4,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.questionBG05
                                : AppColors.grey500,
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
