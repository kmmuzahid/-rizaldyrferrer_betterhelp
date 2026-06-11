import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/generate_task/domain_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateTaskDialog extends StatelessWidget {
  const GenerateTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 24),
          vertical: AppSize.height(value: 32),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5F7), // Light blue background from image
          borderRadius: BorderRadius.circular(AppSize.width(value: 20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: "Choose Your First/Second/Third Domain",
                fontFamilyIndex: 1, // Playfair Display
                fontSize: AppSize.width(value: 20),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF131927),
                maxLines: 5,
              ),
              Gap(height: AppSize.height(value: 18)),
              AppText(
                text: "Why focus on just 3 areas?",
                fontFamilyIndex: 2, // Inter
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF131927),
              ),
              Gap(height: AppSize.height(value: 16)),
              AppText(
                text:
                    "Building new habits works best when you keep it simple. "
                    "Research shows that trying to change too many things at once "
                    "can feel overwhelming and lead to burnout.",
                fontFamilyIndex: 2,
                maxLines: 10,
                fontSize: AppSize.width(value: 14),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6D717F),
                textAlign: TextAlign.center,
                lineHeight: 1.6,
              ),
              Gap(height: AppSize.height(value: 16)),
              AppText(
                text:
                    "That's why we help you focus on just three areas at a time. "
                    "This makes it easier to stay consistent, see progress, and build real momentum.",
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6D717F),
                textAlign: TextAlign.center,
                maxLines: 10,
                lineHeight: 1.6,
              ),
              Gap(height: AppSize.height(value: 16)),
              AppText(
                text:
                    "Don't worry - you can always update your focus areas anytime as your goals change.",
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6D717F),
                textAlign: TextAlign.center,
                lineHeight: 1.6,
                maxLines: 10,
              ),
              Gap(height: AppSize.height(value: 32)),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Get.dialog(const DomainSelectionDialog());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 24),
          vertical: AppSize.height(value: 12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.width(value: 30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: "Continue",
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF131927),
            ),
            Gap(width: AppSize.width(value: 12)),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF131927),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
