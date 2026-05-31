import 'dart:ui';

import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/supports_sections/main_supports/controller/support_screen_controller.dart'
    show SupportScreenController;
import 'package:better_help/screen/supports_sections/main_supports/widgets/chat_bubble.dart';
import 'package:better_help/screen/supports_sections/main_supports/widgets/common_chat_header.dart';
import 'package:better_help/screen/supports_sections/main_supports/widgets/delay_picker.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_appbar/app_content_appbar.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    final profileController = Get.find<MyProfileScreenController>();
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
                  CommonChatHeader(
                    title: 'Health Assistant',
                    subtitle: 'Health Assistant',
                  ),
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
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            Expanded(
                              child:
                                  controller.isLoading.value &&
                                      controller.messageModel.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : CkListView(
                                      isReverse: true,
                                      limit: 20,
                                      onLoadMore: (page) {
                                        controller.getMessages(page: page);
                                      },
                                      itemCount: controller.messageModel.length,
                                      itemBuilder: (context, i) {
                                        final finalIndex =
                                            (controller.messageModel.length -
                                                1) -
                                            i;
                                        final message =
                                            controller.messageModel[finalIndex];
                                        return CommonChatBubble(
                                          message: message,
                                          index: finalIndex,
                                          onButtonTap: (value) async {
                                            if (message.messageType ==
                                                    'pending-start-time' &&
                                                value == '2' &&
                                                message.status == 'pending') {
                                              Get.dialog<int>(
                                                DelayPicker(
                                                  onSelect: (delay) {
                                                    controller.sendMessage(
                                                      message: value,
                                                      index: finalIndex,
                                                      delayMinute: delay,
                                                    );
                                                  },
                                                ),
                                              );

                                              return;
                                            }
                                            controller.sendMessage(
                                              message: value,
                                              index: finalIndex,
                                            );
                                          },
                                          timestamp:
                                              message.createdAt
                                                      .toLocal()
                                                      .date ==
                                                  DateTime.now().toLocal().date
                                              ? CkUtils.formatTime(
                                                  message.createdAt.toLocal(),
                                                )
                                              : CkUtils.formatDateTimeToHms(
                                                  message.createdAt.toLocal(),
                                                ),
                                          isSender:
                                              message.sender.id ==
                                              profileController
                                                  .profileData
                                                  .value
                                                  ?.id,
                                        );
                                      },
                                    ),
                            ),

                            Container(
                              height: 30,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      if (controller.replyIndex > -1)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              controller.replyIndex.value = -1;
                            },
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.black.withAlpha(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          CkText(
                                            text: controller
                                                .messageModel[controller
                                                    .replyIndex
                                                    .value]
                                                .message,
                                            maxLines: 10,
                                            fontSize: 14,
                                            textColor: Colors.black87,
                                            textAlign: TextAlign.left,
                                            isDescription: true,
                                          ),
                                          10.height,
                                          CkTextField(
                                            validationType: CkValidationType
                                                .validateRequired,
                                            hintText: 'Reply to message',
                                            onChanged: (value) {
                                              controller.replyMessage = value;
                                            },
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                if (controller
                                                    .replyMessage
                                                    .isNotEmpty) {
                                                  controller.sendMessage(
                                                    message:
                                                        controller.replyMessage,
                                                    index: controller
                                                        .replyIndex
                                                        .value,
                                                  );
                                                  controller.replyMessage = '';
                                                  controller.replyIndex.value =
                                                      -1;
                                                }
                                              },
                                              icon: Icon(Icons.send),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    20.height,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
              CkText(
                text: "Next Appointment",
                textColor: AppColors.accelerationButton,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.bookingsSessions);
                },
                child: CkText(
                  top: 4,
                  bottom: 4,
                  left: 8,
                  right: 8,
                  borderColor: Colors.white,
                  backgroundColor: Colors.white,
                  preffix: Icon(Icons.calendar_today_outlined),
                  text: getBookingDate() ?? 'No Appointment',
                  textColor: AppColors.accelerationButton,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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

  String? getBookingDate() {
    if (controller.bookedSessionModel.value?.startTime == null) {
      return null;
    }
    return '${DateFormat('MMM dd yyyy').format(controller.bookedSessionModel.value?.startTime.toLocal() ?? DateTime.now())} ${DateFormat("h:mm a").format(controller.bookedSessionModel.value?.startTime.toLocal() ?? DateTime.now())}';
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
