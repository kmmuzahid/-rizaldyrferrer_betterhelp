import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlexibleCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  //! Leading widget options
  final String? leadingImagePath;
  final String? leadingSvgPath;
  final bool showCircleAvatar;
  final bool showLeading;
  final Widget? customLeading;

  //! Title content
  final String title;
  final String subtitle;

  //! Actions
  final String? notificationIconPath;
  final String? menuIconPath;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;
  final bool showNotification;
  final bool showMenu;
  final bool openDrawerOnMenuTap;

  //! Styling (using your existing approach)
  final double appBarHeight;
  final Color backgroundColor;
  final Color textColor;
  final double titleFontSize;
  final double subtitleFontSize;
  final FontWeight titleFontWeight;
  final FontWeight subtitleFontWeight;
  final int fontFamilyIndex;
  final double leadingSize;
  final double iconSize;
  final double leadingPadding;
  final double actionSpacing;
  final double endPadding;

  const FlexibleCustomAppBar({
    super.key,
    //! Leading options
    this.leadingImagePath,
    this.leadingSvgPath,
    this.showCircleAvatar = true,
    this.showLeading = true,
    this.customLeading,

    //! Title content
    required this.title,
    required this.subtitle,

    //! Actions
    this.notificationIconPath,
    this.menuIconPath,
    this.onNotificationTap,
    this.onMenuTap,
    this.showNotification = true,
    this.showMenu = true,
    this.openDrawerOnMenuTap = true,

    //! Styling
    this.appBarHeight = 70,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.titleFontSize = 18,
    this.subtitleFontSize = 14,
    this.titleFontWeight = FontWeight.w600,
    this.subtitleFontWeight = FontWeight.w500,
    this.fontFamilyIndex = 2,
    this.leadingSize = 48,
    this.iconSize = 24,
    this.leadingPadding = 20,
    this.actionSpacing = 30,
    this.endPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        leading: showLeading ? _buildLeading() : null,
        title: _buildTitle(),
        actions: _buildActions(context),
      ),
    );
  }

  Widget? _buildLeading() {
    //! If custom leading is provided, use it
    if (customLeading != null) {
      return customLeading;
    }

    //! If no leading content is specified, return null
    if (leadingImagePath == null && leadingSvgPath == null) {
      return null;
    }

    Widget leadingContent;

    //! Build the leading content (image or SVG)
    if (leadingSvgPath != null) {
      leadingContent = SvgPicture.asset(
        leadingSvgPath!,
        height: leadingSize,
        width: leadingSize,
        fit: BoxFit.contain,
      );
    } else if (leadingImagePath != null) {
      leadingContent = Image.asset(
        leadingImagePath!,
        height: leadingSize,
        width: leadingSize,
        fit: BoxFit.contain,
      );
    } else {
      return null;
    }

    //! Wrap in CircleAvatar if specified
    if (showCircleAvatar) {
      return CircleAvatar(
        radius: 100,
        backgroundColor: backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(left: leadingPadding),
          child: leadingContent,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: leadingPadding),
        child: leadingContent,
      );
    }
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          fontFamilyIndex: 2,
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
          color: textColor,
        ),
        // Text(
        //   title,
        //   style: TextStyle(
        //     fontFamily: _getFontFamily(fontFamilyIndex),
        //     fontSize: titleFontSize,
        //     fontWeight: titleFontWeight,
        //     color: textColor,
        //   ),
        // ),
        // Text(
        //   subtitle,
        //   style: TextStyle(
        //     fontFamily: _getFontFamily(fontFamilyIndex),
        //     fontSize: subtitleFontSize,
        //     fontWeight: subtitleFontWeight,
        //     color: textColor,
        //   ),
        // ),
        AppText(
          text: subtitle,
          fontFamilyIndex: 2,
          fontSize: subtitleFontSize,
          fontWeight: subtitleFontWeight,
          color: textColor,
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    List<Widget> actions = [];

    //! Notification icon
    if (showNotification && notificationIconPath != null) {
      actions.add(
        GestureDetector(
          onTap:
              onNotificationTap ??
              () {
                // Default behavior - you can customize this
                //Navigator.pushNamed(context, '/notifications');
              },
          child: SvgPicture.asset(
            notificationIconPath!,
            height: iconSize,
            width: iconSize,
          ),
        ),
      );
      actions.add(SizedBox(width: actionSpacing));
    }

    // Menu icon
    if (showMenu && menuIconPath != null) {
      actions.add(
        GestureDetector(
          onTap:
              onMenuTap ??
              () {
                if (openDrawerOnMenuTap) {
                  // Try to open end drawer first, then regular drawer
                  if (Scaffold.of(context).hasEndDrawer) {
                    Scaffold.of(context).openEndDrawer();
                  } else if (Scaffold.of(context).hasDrawer) {
                    Scaffold.of(context).openDrawer();
                  }
                }
              },
          child: SvgPicture.asset(
            menuIconPath!,
            height: iconSize,
            width: iconSize,
          ),
        ),
      );
      actions.add(SizedBox(width: endPadding));
    }

    return actions;
  }

  // String? _getFontFamily(int index) {
  //   // You can customize this based on your app's font families
  //   switch (index) {
  //     case 1:
  //       return 'Roboto';
  //     case 2:
  //       return 'Poppins';
  //     case 3:
  //       return 'Inter';
  //     default:
  //       return null;
  //   }
  // }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
