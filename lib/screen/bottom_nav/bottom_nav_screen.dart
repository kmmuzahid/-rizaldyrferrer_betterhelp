import 'package:better_help/screen/bottom_nav/controller/bottom_nav_screen_controller.dart';
import 'package:better_help/screen/community/main_community/community_screen.dart';
import 'package:better_help/screen/habits/main_habits/habits_screen.dart';
import 'package:better_help/screen/learn/main_learn/learn_screen.dart';
import 'package:better_help/screen/progress/main_progress/progress_screen.dart';
import 'package:better_help/screen/supports/main_supports/support_screen.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Move the GlobalKey outside of GetBuilder to prevent recreation
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final BottomNavScreenController controller = Get.put(
      BottomNavScreenController(),
    );

    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: AppColors.instance.white50,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset(
      //         AppAssertImage.instance.logoIcon,
      //         height: 40,
      //         width: 40,
      //       ),
      //     ],
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //     onPressed: () {
      //       scaffoldKey.currentState?.openDrawer();
      //     },
      //     icon: SvgPicture.asset(AppAssertIcons.userMenu),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {}, // Add functionality for notifications
      //       icon: SvgPicture.asset(AppAssertIcons.userNotification),
      //     ),
      //   ],
      // ),
      //drawer: const UserMenuDrawer(),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            ////////// index 0
            HabitsScreen(),
            ////////// index 1
            LearnScreen(),
            /////////// index 2
            SupportScreen(),
            /////////// index 3
            ProgressScreen(),
            /////////// index 4 -
            CommunityScreen(),
          ],
        ),
      ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: ClipOval(
      //   child: Container(
      //     padding: EdgeInsets.all(6),
      //     decoration: BoxDecoration(
      //       color: AppColors.instance.green500.withAlpha(80),
      //       borderRadius: BorderRadius.circular(100),
      //     ),
      //     child: Material(
      //       color: AppColors.instance.green500,
      //       borderRadius: BorderRadius.circular(100),
      //       child: InkWell(
      //         onTap: () {
      //           controller.changeIndex(4);
      //         },
      //         borderRadius: BorderRadius.circular(100),
      //         child: Container(
      //           width: AppSize.width(value: 50),
      //           height: AppSize.height(value: 50),
      //           alignment: Alignment.center,
      //           child: SvgPicture.asset(
      //             AppAssertIcons.uProduct,
      //             height: AppSize.width(value: 22),
      //             width: AppSize.height(value: 22),
      //             colorFilter: ColorFilter.mode(
      //               AppColors.instance.white50,
      //               BlendMode.srcIn,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Container(
        height: AppSize.height(value: 70),
        padding: EdgeInsets.symmetric(vertical: AppSize.width(value: 8)),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //////////////////  home
              GestureDetector(
                onTap: () {
                  controller.changeIndex(0);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.selectedIndex.value == 0
                        ? Container(
                            height: AppSize.height(value: 4),
                            width: AppSize.width(value: 30),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(height: 4),
                    SvgPicture.asset(
                      controller.selectedIndex.value == 0
                          ? AppIcons.habitsFill
                          : AppIcons.habits,
                      width: AppSize.width(value: 18),
                      height: AppSize.height(value: 18),
                    ),
                    AppText(
                      text: AppString.habits,
                      color: controller.selectedIndex.value == 0
                          ? AppColors.primary500
                          : AppColors.secondary500,
                    ),
                  ],
                ),
              ),

              ////////////  Search
              GestureDetector(
                onTap: () {
                  controller.changeIndex(1);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.selectedIndex.value == 1
                        ? Container(
                            height: AppSize.height(value: 4),
                            width: AppSize.width(value: 30),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(height: 4),
                    SvgPicture.asset(
                      controller.selectedIndex.value == 1
                          ? AppIcons.learnFill
                          : AppIcons.learn,
                      width: AppSize.width(value: 18),
                      height: AppSize.height(value: 18),
                    ),
                    AppText(
                      text: AppString.learn,
                      color: controller.selectedIndex.value == 1
                          ? AppColors.primary500
                          : AppColors.secondary500,
                    ),
                  ],
                ),
              ),
              //////////// support
              GestureDetector(
                onTap: () {
                  controller.changeIndex(2);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.selectedIndex.value == 2
                        ? Container(
                            height: AppSize.height(value: 4),
                            width: AppSize.width(value: 30),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(height: 4),
                    SvgPicture.asset(
                      controller.selectedIndex.value == 2
                          ? AppIcons.supportFill
                          : AppIcons.support,
                      width: AppSize.width(value: 18),
                      height: AppSize.height(value: 18),
                    ),
                    AppText(
                      text: AppString.support,
                      color: controller.selectedIndex.value == 2
                          ? AppColors.primary500
                          : AppColors.secondary500,
                    ),
                  ],
                ),
              ),
              //////////// account
              GestureDetector(
                onTap: () {
                  controller.changeIndex(3);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.selectedIndex.value == 3
                        ? Container(
                            height: AppSize.height(value: 4),
                            width: AppSize.width(value: 30),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(height: 4),
                    SvgPicture.asset(
                      controller.selectedIndex.value == 3
                          ? AppIcons.progressFill
                          : AppIcons.progress,
                      width: AppSize.width(value: 18),
                      height: AppSize.height(value: 18),
                    ),
                    AppText(
                      text: AppString.progress,
                      color: controller.selectedIndex.value == 3
                          ? AppColors.primary500
                          : AppColors.secondary500,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.changeIndex(4);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.selectedIndex.value == 4
                        ? Container(
                            height: AppSize.height(value: 4),
                            width: AppSize.width(value: 30),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(height: 4),
                    SvgPicture.asset(
                      controller.selectedIndex.value == 4
                          ? AppIcons.communityFill
                          : AppIcons.community,
                      width: AppSize.width(value: 18),
                      height: AppSize.height(value: 18),
                    ),
                    AppText(
                      text: AppString.community,
                      color: controller.selectedIndex.value == 4
                          ? AppColors.primary500
                          : AppColors.secondary500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
