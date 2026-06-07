import 'package:better_help/core/compatibility/corekit_compat.dart';
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
  final String questionText;
  final int questionNumber;
  final Color? selectedAnswerColor;
  final Color? answerCardBg;

  const CustomQuestionContainer({
    super.key,
    required this.controller,
    required this.questionText,
    required this.questionNumber,
    this.selectedAnswerColor,
    this.answerCardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.answerCardBgColor,
        borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
      ),
      child: Column(
        children: [
          Gap(height: AppSize.height(value: 14)),
          AppText(
            text: questionText,
            fontFamilyIndex: 1,
            fontWeight: FontWeight.w600,
            fontSize: AppSize.width(value: 16),
            lineHeight: 1.40,
            color: AppColors.t3,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          8.height,
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
        borderRadius: BorderRadius.circular(AppSize.width(value: 16)),
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAnswerOption('Rarely/Never', AppString.rarely),
            _buildAnswerOption('sometimes', AppString.sometimes),
            _buildAnswerOption('frequently', AppString.frequently),
          ],
        );
      }),
    );
  }

  Widget _buildAnswerOption(String answerValue, String answerText) {
    final Color activeColor =
        selectedAnswerColor ?? AppColors.questionBG01StatusBarColor;
    final bool isSelected = controller.isAnswerSelected(
      questionNumber,
      answerValue,
    );

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectAnswer(questionNumber, answerValue),
        child: Column(
          children: [
            Container(
              width: AppSize.width(value: 24),
              height: AppSize.width(value: 24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: activeColor, width: 2),
                color: isSelected ? activeColor : Colors.transparent,
              ),
              child: isSelected
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
              fontSize: 13,
              fontFamilyIndex: 2,
              fontWeight: FontWeight.w600,
              color: isSelected ? activeColor : AppColors.black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
