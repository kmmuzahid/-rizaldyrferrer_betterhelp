import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionnaireSummaryScreen extends StatefulWidget {
  const QuestionnaireSummaryScreen({super.key});

  @override
  State<QuestionnaireSummaryScreen> createState() =>
      _QuestionnaireSummaryScreenState();
}

class _QuestionnaireSummaryScreenState extends State<QuestionnaireSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.questionBG04,
      body: SafeArea(
        child: data == null ? _buildErrorState() : _buildSummaryContent(data),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            text: 'No data available',
            fontSize: AppSize.width(value: 18),
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          Gap(height: AppSize.height(value: 20)),
          AppButton(
            title: 'Continue',
            backgroundColor: AppColors.white,
            titleColor: AppColors.black,
            onTap: () => Get.offNamed(AppRoute.freeTrialScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContent(Map<String, dynamic> data) {
    final selfInsight = data['Your Self-Insight Summary'] as String? ?? '';
    final whatWeLearned = data['What We Learned About You'] as List? ?? [];
    final growthData = data['But You Also Want to Grow'] as Map? ?? {};
    final programTip =
        data['Try the Program that Works With Your Brain'] as String? ?? '';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.all(AppSize.width(value: 16)),
          child: Column(
            children: [
              Gap(height: AppSize.height(value: 20)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 12),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Your Self-Insight Summary'),
                        Gap(height: AppSize.height(value: 8)),
                        AppText(
                          text: selfInsight,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey500,
                          fontFamilyIndex: 2,
                          lineHeight: 1.5,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.left,
                        ),
                        Gap(height: AppSize.height(value: 20)),
                        _buildDivider(),
                        Gap(height: AppSize.height(value: 20)),
                        _buildSectionTitle('What We Learned About You'),
                        Gap(height: AppSize.height(value: 12)),
                        ...whatWeLearned.map(
                          (item) => _buildBulletPoint(item.toString()),
                        ),
                        Gap(height: AppSize.height(value: 20)),
                        _buildDivider(),
                        Gap(height: AppSize.height(value: 20)),
                        _buildGrowthSection(growthData),
                        Gap(height: AppSize.height(value: 20)),
                        _buildDivider(),
                        Gap(height: AppSize.height(value: 20)),
                        _buildSectionTitle(
                          'Try the Program that Works With Your Brain',
                        ),
                        Gap(height: AppSize.height(value: 8)),
                        AppText(
                          text: programTip,
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey500,
                          fontFamilyIndex: 2,
                          lineHeight: 1.5,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(height: AppSize.height(value: 20)),
              AppButton(
                title: 'Continue',
                backgroundColor: AppColors.white,
                titleColor: AppColors.black,
                onTap: () => Get.offNamed(AppRoute.freeTrialScreen),
              ),
              Gap(height: AppSize.height(value: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: AppSize.width(value: 16),
      fontWeight: FontWeight.w600,
      color: AppColors.black,
      fontFamilyIndex: 2,
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.grey500.withOpacity(0.2));
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.height(value: 8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppSize.height(value: 6)),
            child: Icon(Icons.circle, size: 6, color: AppColors.questionBG05),
          ),
          Gap(width: AppSize.width(value: 10)),
          Expanded(
            child: AppText(
              text: text,
              fontSize: AppSize.width(value: 14),
              fontWeight: FontWeight.w400,
              color: AppColors.grey500,
              fontFamilyIndex: 2,
              lineHeight: 1.4,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthSection(Map growthData) {
    final mainGoal =
        growthData['You said your main goal is/are'] as String? ?? '';
    final positiveGoals = growthData['Positive Growth Goals'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('But You Also Want to Grow'),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: 'Your main goal: $mainGoal',
          fontSize: AppSize.width(value: 14),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          fontFamilyIndex: 2,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
        ),
        Gap(height: AppSize.height(value: 12)),
        AppText(
          text: 'Positive Growth Goals:',
          fontSize: AppSize.width(value: 14),
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          fontFamilyIndex: 2,
        ),
        Gap(height: AppSize.height(value: 8)),
        ...positiveGoals.map(
          (goal) => Padding(
            padding: EdgeInsets.only(bottom: AppSize.height(value: 6)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.questionBG05,
                ),
                Gap(width: AppSize.width(value: 8)),
                Expanded(
                  child: AppText(
                    text: goal.toString(),
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey500,
                    fontFamilyIndex: 2,
                    lineHeight: 1.4,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
