import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DifficultiesSelectionDialog extends StatefulWidget {
  const DifficultiesSelectionDialog({super.key});

  @override
  State<DifficultiesSelectionDialog> createState() =>
      _DifficultiesSelectionDialogState();
}

class _DifficultiesSelectionDialogState
    extends State<DifficultiesSelectionDialog> {
  final List<String> difficulties = [
    "Executive Inhibition (Self-Restraint)",
    "Goal-Directed Persistence (Self-Motivation)",
    "Planning and Problem-Solving",
    "Self-Awareness (Meta-Cognition)",
    "Verbal Working Memory",
    "Non-Verbal Working Memory",
    "Emotional Dysregulation",
    "Other Areas (General Life Management)",
  ];

  final List<String> selectedDifficulties = [];
  String? activeTooltip;

  void toggleDifficulty(String difficulty) {
    setState(() {
      if (selectedDifficulties.contains(difficulty)) {
        selectedDifficulties.remove(difficulty);
      } else {
        if (selectedDifficulties.length < 3) {
          selectedDifficulties.add(difficulty);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(value: 20),
              vertical: AppSize.height(value: 30),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD6CDEB), // Exact color from image
              borderRadius: BorderRadius.circular(AppSize.width(value: 20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: "8 Domains of Life\nManagement Difficulties",
                  fontFamilyIndex: 1,
                  fontSize: AppSize.width(value: 26),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF393433),
                  lineHeight: 1.2,
                ),
                Gap(height: AppSize.height(value: 8)),
                AppText(
                  text: "Choose up to 3",
                  fontFamilyIndex: 2,
                  fontSize: AppSize.width(value: 18),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF393433),
                ),
                Gap(height: AppSize.height(value: 24)),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: difficulties.length,
                    separatorBuilder: (context, index) => Gap(height: 16),
                    itemBuilder: (context, index) {
                      final difficulty = difficulties[index];
                      final isSelected = selectedDifficulties.contains(
                        difficulty,
                      );
                      return _buildDifficultyItem(difficulty, isSelected);
                    },
                  ),
                ),
                Gap(height: AppSize.height(value: 32)),
                _buildNextButton(),
              ],
            ),
          ),
          if (activeTooltip != null) _buildTooltip(),
        ],
      ),
    );
  }

  Widget _buildDifficultyItem(String difficulty, bool isSelected) {
    return GestureDetector(
      onTap: () => toggleDifficulty(difficulty),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF6D717F).withValues(alpha: 0.5),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(2),
              color: isSelected ? const Color(0xFF393433) : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          Gap(width: 12),
          Expanded(
            child: AppText(
              text: difficulty,
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 13),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF545454),
              textAlign: TextAlign.left,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (activeTooltip == difficulty) {
                  activeTooltip = null;
                } else {
                  activeTooltip = difficulty;
                }
              });
            },
            child: const Icon(
              Icons.info_outline,
              size: 18,
              color: Color(0xFF393433),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTooltip() {
    return Positioned(
      bottom: AppSize.height(value: 180), // Adjust based on layout
      left: AppSize.width(value: 80),
      right: AppSize.width(value: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            AppText(
              text: "I forget where I put things or what I was about to do.",
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 12),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF393433),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Container(
        width: AppSize.width(value: 160),
        padding: EdgeInsets.symmetric(vertical: AppSize.height(value: 12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.width(value: 30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppText(
          text: "Next",
          fontFamilyIndex: 2,
          fontSize: AppSize.width(value: 20),
          fontWeight: FontWeight.w700,
          color: const Color(0xFF131927),
        ),
      ),
    );
  }
}
