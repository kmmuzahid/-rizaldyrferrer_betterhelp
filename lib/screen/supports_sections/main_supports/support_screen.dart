import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_chat_widget/app_chat_widget.dart';
import 'package:better_help/widget/app_chat_widget/models/chat_models.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SupportScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const SupportScreen({super.key, this.scaffoldKey});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  // Chat widget key to prevent rebuilds
  final GlobalKey _chatKey = GlobalKey();

  // Mock data for chat
  final List<ChatMessage> _mockMessages = [
    ChatMessage(
      id: '1',
      text: 'Hi 👋 Welcome to Health Assistant!',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      senderName: 'Health Assistant',
      senderAvatar: 'https://via.placeholder.com/40/4DB6AC/FFFFFF?text=HA',
    ),
    ChatMessage(
      id: '2',
      text: 'How can I help you today?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
      senderName: 'Health Assistant',
      senderAvatar: 'https://via.placeholder.com/40/4DB6AC/FFFFFF?text=HA',
    ),
    ChatMessage(
      id: '3',
      text: 'I need some guidance about my health routine',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
    ),
    ChatMessage(
      id: '4',
      text:
          'I\'d be happy to help! What specific area would you like to focus on?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      senderName: 'Health Assistant',
      senderAvatar: 'https://via.placeholder.com/40/4DB6AC/FFFFFF?text=HA',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Chat integration will be implemented when API is ready
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
      body: SingleChildScrollView(
        child: Column(
          // Changed from SingleChildScrollView to Column
          children: [
            // Quick action buttons - wrapped in container with fixed height
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
                vertical: 20,
              ),
              child: Row(
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
            ),

            // Chat widget - takes remaining space
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              margin: EdgeInsets.fromLTRB(
                AppSize.width(value: 20),
                0,
                AppSize.width(value: 20),
                20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ModernChatWidget(
                  key: _chatKey, // Add key to prevent rebuilds
                  title: 'Health Assistant',
                  subtitle: 'Online',
                  chatId:
                      'health_assistant_chat_${widget.hashCode}', // Make unique
                  recipientAvatar:
                      'https://via.placeholder.com/40/4DB6AC/FFFFFF?text=HA',
                  showOnlineStatus: true,
                  primaryColor: Color(0xFF4DB6AC),
                  backgroundColor: Color(0xFFF5F7FA),
                  initialMessages: _mockMessages,
                  showHeader: true,
                  onMessageSent: (message) {
                    // Mock response - simulate bot reply
                    Future.delayed(Duration(seconds: 2), () {
                      // In a real app, this would send to your API
                      appLog('User sent: $message');
                    });
                  },
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
