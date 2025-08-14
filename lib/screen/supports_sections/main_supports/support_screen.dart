import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const SupportScreen({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlexibleCustomAppBar(
        title: AppString.seekExpartSupports,
        subtitle: AppString.directContactWithBha,
        leadingImagePath: AppStaticImages.supportAppbar,
        appBarHeight: AppSize.height(value: 70),
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
        onMenuTap: () => scaffoldKey?.currentState?.openDrawer(),
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.calendar_today,
                    title: 'Book Session',
                    color: Color(0xFF0095FF),
                    backgroundColor: Color(0xFFF2F7FF),
                    onTap: () {
                      // Handle booking
                    },
                  ),
                ),
                Gap(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.report_problem,
                    title: 'Report Problem',
                    color: Color(0xFFEE443F),
                    backgroundColor: Color(0xFFFFF3F2),
                    onTap: () {
                      // Handle report
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            Gap(width: 8),
            Flexible(
              child: AppText(
                text: title,
                color: color,
                fontSize: 12,
                fontFamilyIndex: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
