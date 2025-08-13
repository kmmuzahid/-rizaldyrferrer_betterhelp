import 'package:better_help/screen/bottom_nav/controller/bottom_nav_screen_controller.dart';
import 'package:better_help/screen/community_sections/main_community/community_screen.dart';
import 'package:better_help/screen/habits_sections/main_habits/habits_screen.dart';
import 'package:better_help/screen/learn_sections/main_learn/learn_screen.dart';
import 'package:better_help/screen/menu_drawer/user_drawer/user_drawer.dart';
import 'package:better_help/screen/progress_sections/main_progress/progress_screen.dart';
import 'package:better_help/screen/supports_sections/main_supports/support_screen.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavScreenController controller = Get.put(
      BottomNavScreenController(),
    );
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const UserDrawer(),
      body: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodySmall: TextStyle(
              fontSize: AppSize.width(value: 13),
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
        ),
        child: Obx(
          () => PersistentTabView(
            context,
            controller: PersistentTabController(
              initialIndex: controller.selectedIndex.value,
            ),
            screens: _buildScreens(scaffoldKey),
            items: _navBarsItems(),
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardAppears: true,
            popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
            padding: EdgeInsets.only(
              top: AppSize.height(value: 2),
              bottom: AppSize.height(value: 8),
            ),
            backgroundColor: AppColors.white,
            isVisible: true,
            bottomScreenMargin: AppSize.height(value: 05),
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: true,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOutExpo,
              ),
            ),
            confineToSafeArea: true,
            navBarHeight: AppSize.height(value: 75),
            navBarStyle: NavBarStyle.style3,
            onItemSelected: (index) {
              controller.changeIndex(index);
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens(GlobalKey<ScaffoldState> scaffoldKey) {
    return [
      HabitsScreen(scaffoldKey: scaffoldKey),
      LearnScreen(scaffoldKey: scaffoldKey),
      SupportScreen(scaffoldKey: scaffoldKey),
      ProgressScreen(scaffoldKey: scaffoldKey),
      CommunityScreen(scaffoldKey: scaffoldKey),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      //! Habits Screen
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.habitsFill,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppIcons.habits,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(
            AppColors.secondary500,
            BlendMode.srcIn,
          ),
        ),
        title: AppString.habits,
        activeColorPrimary: AppColors.primary500,
        inactiveColorPrimary: AppColors.secondary500,
      ),
      //! Learn Screen
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.learnFill,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppIcons.learn,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(
            AppColors.secondary500,
            BlendMode.srcIn,
          ),
        ),
        title: AppString.learn,
        activeColorPrimary: AppColors.primary500,
        inactiveColorPrimary: AppColors.secondary500,
      ),
      //! Support Screen
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.supportFill,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppIcons.support,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(
            AppColors.secondary500,
            BlendMode.srcIn,
          ),
        ),
        title: AppString.support,
        activeColorPrimary: AppColors.primary500,
        inactiveColorPrimary: AppColors.secondary500,
      ),
      //! Progress Screen
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.progressFill,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppIcons.progress,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(
            AppColors.secondary500,
            BlendMode.srcIn,
          ),
        ),
        title: AppString.progress,
        activeColorPrimary: AppColors.primary500,
        inactiveColorPrimary: AppColors.secondary500,
      ),
      //! Community Screen
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.communityFill,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppIcons.community,
          width: AppSize.width(value: 25),
          height: AppSize.height(value: 25),
          colorFilter: ColorFilter.mode(
            AppColors.secondary500,
            BlendMode.srcIn,
          ),
        ),
        title: AppString.community,
        activeColorPrimary: AppColors.primary500,
        inactiveColorPrimary: AppColors.secondary500,
      ),
    ];
  }
}
