import 'package:better_help/screen/questionnaries_screen/controller/questionnaries_screen_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomQuestionContainer extends StatelessWidget {
  final QuestionnariesScreenController controller;
  final String questionImage;
  final String questionText;
  final int questionNumber;
  final int totalQuestions;
  final Color? badgeBackgroundColor;
  final Color? selectedAnswerColor;
  final Color? answerCardBg;

  const CustomQuestionContainer({
    super.key,
    required this.controller,
    required this.questionImage,
    required this.questionText,
    required this.questionNumber,
    required this.totalQuestions,
    this.badgeBackgroundColor,
    this.selectedAnswerColor,
    this.answerCardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.width(value: 12)),
        ),
      ),
      child: Column(
        children: [
          // Question Number Badge
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 12.5),
                vertical: AppSize.height(value: 3),
              ),
              decoration: BoxDecoration(
                color:
                    badgeBackgroundColor ??
                    AppColors.questionBG01StatusBarColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSize.width(value: 10)),
                ),
              ),
              child: AppText(
                text: '$questionNumber/$totalQuestions',
                fontSize: AppSize.width(value: 16),
                lineHeight: 1.4,
                letterSpacing: 0.08,
                fontFamilyIndex: 2,
                fontWeight: FontWeight.w600,
                color: AppColors.white50,
              ),
            ),
          ),

          // Question Image
          Image.asset(
            questionImage,
            height: AppSize.height(value: 115),
            width: AppSize.width(value: 115),
          ),

          // Question Text
          Gap(height: AppSize.height(value: 14)),
          AppText(
            text: questionText,
            fontFamilyIndex: 5,
            fontWeight: FontWeight.w600,
            fontSize: AppSize.width(value: 16),
            lineHeight: 1.40,
            color: AppColors.t3,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),

          // Answer Selection
          Gap(height: AppSize.height(value: 14)),
          _buildAnswerSelection(),
        ],
      ),
    );
  }

  Widget _buildAnswerSelection() {
    return Container(
      padding: EdgeInsets.all(AppSize.width(value: 16)),
      decoration: BoxDecoration(
        color: answerCardBg ?? AppColors.yellow50,
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.width(value: 16)),
        ),
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnswerOption('rarely', AppString.rarely),
            _buildAnswerOption('frequently', AppString.frequently),
            _buildAnswerOption('sometimes', AppString.sometimes),
          ],
        );
      }),
    );
  }

  Widget _buildAnswerOption(String answerValue, String answerText) {
    final Color activeColor =
        selectedAnswerColor ?? AppColors.questionBG01StatusBarColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectAnswer(answerValue),
        child: Column(
          children: [
            Container(
              width: AppSize.width(value: 24),
              height: AppSize.width(value: 24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.isAnswerSelected(answerValue)
                      ? activeColor
                      : AppColors.grey500,
                  width: 2,
                ),
                color: controller.isAnswerSelected(answerValue)
                    ? activeColor
                    : Colors.transparent,
              ),
              child: controller.isAnswerSelected(answerValue)
                  ? Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: AppSize.width(value: 16),
                    )
                  : null,
            ),
            Gap(height: AppSize.height(value: 8)),
            AppText(
              text: answerText,
              fontSize: AppSize.width(value: 14),
              fontFamilyIndex: 2,
              fontWeight: FontWeight.w600,
              color: controller.isAnswerSelected(answerValue)
                  ? activeColor
                  : AppColors.black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
