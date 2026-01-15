import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/supports_sections/main_supports/controller/support_screen_controller.dart'
    show SupportScreenController;
import 'package:better_help/screen/supports_sections/main_supports/widgets/chat_bubble.dart';
import 'package:better_help/screen/supports_sections/main_supports/widgets/common_chat_header.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const SupportScreen({super.key, this.scaffoldKey});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late SupportScreenController controller;

  @override
  void initState() {
    controller = Get.find<SupportScreenController>(); 
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FlexibleCustomAppBar(
        title: AppString.seekExpartSupports,
        subtitle: AppString.directContactWithBha,
        leadingImagePath: AppStaticImages.supportAppbar,
        appBarHeight: AppSize.height(value: 70),
        notificationIconPath: AppIcons.notificationIcons,
        menuIconPath: AppIcons.menuIcons,
        onMenuTap: () => widget.scaffoldKey?.currentState?.openDrawer(),
      ),
      backgroundColor: AppColors.white,
      body: Obx(
        () => Column(
          children: [
            10.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _header(),
                  10.height,
                  CommonChatHeader(title: 'Kris', subtitle: 'Health Assistant'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade200),
                      right: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SmartListLoader(
                          isReverse: true,
                          onLoadMore: (page) {
                            controller.getMessages(page: page + 1);
                          },
                          itemCount: controller.messageModel.length,
                          itemBuilder: (context, index) {
                            final message = controller.messageModel[index];
                            return CommonChatBubble(
                              text: message.message,
                              timestamp: message.createdAt.date == DateTime.now().date
                                  ? CoreUtils.formatTime(message.createdAt)
                                  : CoreUtils.formatDateTimeToHms(message.createdAt),
                              isSender: message.sender.id == StorageService.userId,
                            );
                          },
                        ),
                      ),
                      _buttons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: AppSize.height(value: 85),
        decoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  Container _buttons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          25.width,
          Expanded(
            child: CommonButton(
              buttonWidth: double.infinity,
              titleText: "Yes",
              buttonColor: const Color(0xFFE0F2F1), // Light teal
              titleColor: const Color(0xFF00796B),
              onTap: () {
                controller.sendMessage(message: "Yes");
              },
            ),
          ),
          20.width,
          Expanded(
            child: CommonButton(
              buttonWidth: double.infinity,
              titleText: "No",
              buttonColor: const Color(0xFFEEEEEE), // Light grey
              titleColor: Colors.black54,
              onTap: () {
                controller.sendMessage(message: "No");
              },
            ),
          ),
          25.width,
        ],
      ),
    );
  }

  Column _header() {
    return Column(
      // Changed from SingleChildScrollView to Column
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.accelerationButton.withAlpha(10),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Row(
            children: [
              CommonText(
                text: "Next Appointment",
                textColor: AppColors.accelerationButton,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              CommonText(
                top: 4,
                bottom: 4,
                left: 8,
                right: 8,
                borderColor: Colors.white,
                backgroundColor: Colors.white,
                preffix: Icon(Icons.calendar_today_outlined),
                text: "11:00 AM 10-27-2025",
                textColor: AppColors.accelerationButton,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        10.height,

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.calendar_today,
                title: 'Book Session',
                color: Color(0xFF0095FF),
                backgroundColor: Color(0xFFF2F7FF),
                onTap: () {
                  Get.toNamed(AppRoute.bookingScreen);
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
                  Get.toNamed(AppRoute.reportProblemScreen);
                },
              ),
            ),
          ],
        ),
      ],
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
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
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
