import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_icons/app_icons.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaPostCard extends StatefulWidget {
  final String postText;
  final String userName;
  final String userLocation;
  final String profileImage;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  // Optional callback functions
  final VoidCallback? onProfileImageTap;
  final VoidCallback? onMoreVertTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;

  const SocialMediaPostCard({
    super.key,
    required this.postText,
    required this.userName,
    required this.userLocation,
    required this.profileImage,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.onProfileImageTap,
    this.onMoreVertTap,
    this.onLikeTap,
    this.onCommentTap,
  });

  @override
  _SocialMediaPostCardState createState() => _SocialMediaPostCardState();
}

class _SocialMediaPostCardState extends State<SocialMediaPostCard> {
  bool isExpanded = false;
  bool isTextOverflowing = false;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Check if text overflows after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final RenderBox? renderBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: widget.postText,
          style: TextStyle(
            fontSize: AppSize.width(value: 14),
            fontWeight: FontWeight.w400,
            letterSpacing: -0.14,
          ),
        ),
        maxLines: 10,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: renderBox.constraints.maxWidth);

      if (textPainter.didExceedMaxLines) {
        setState(() {
          isTextOverflowing = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      margin: EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: const Color(0xFFEAF5F7),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.03, color: const Color(0x19718096)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10.35,
            offset: Offset(1.03, 1.03),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Row
          Row(
            children: [
              // Profile Image with Optional Click
              GestureDetector(
                onTap: widget.onProfileImageTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.profileImage.startsWith('http')
                      ? Image.network(
                          widget.profileImage,
                          height: AppSize.height(value: 35),
                          width: AppSize.width(value: 35),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: AppSize.height(value: 35),
                              width: AppSize.width(value: 35),
                              color: AppColors.grey100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary500,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to a default icon if network image fails
                            return Container(
                              height: AppSize.height(value: 35),
                              width: AppSize.width(value: 35),
                              color: AppColors.grey100,
                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: AppColors.white,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          widget.profileImage,
                          height: AppSize.height(value: 35),
                          width: AppSize.width(value: 35),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Gap(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.userName,
                      fontSize: AppSize.width(value: 14.38),
                      fontFamilyIndex: 2,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(height: 02),
                    AppText(
                      text: widget.userLocation,
                      fontSize: AppSize.width(value: 12.33),
                      fontFamilyIndex: 2,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // More Options Button with Optional Click
              GestureDetector(
                onTap: widget.onMoreVertTap,
                child: Icon(Icons.more_vert_outlined, size: 20),
              ),
            ],
          ),
          Gap(height: 12),

          // Post Content with Expandable Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                key: _textKey,
                text: widget.postText,
                fontFamilyIndex: 2,
                fontSize: AppSize.width(value: 14),
                fontWeight: FontWeight.w400,
                maxLines: isExpanded ? null : 10,
                letterSpacing: -0.14,
                overflow: isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),

              // See More / See Less Button
              if (isTextOverflowing)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: AppText(
                      text: isExpanded ? "See Less" : "See More",
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w600,
                      fontFamilyIndex: 2,
                      letterSpacing: -0.14,
                      color: const Color(
                        0xFF1DA1F2,
                      ), // Twitter blue or your app's primary color
                    ),
                  ),
                ),
            ],
          ),

          Gap(height: 12),

          // Divider
          Divider(color: AppColors.grey100, thickness: 1.5),

          // Action Buttons Row
          Row(
            children: [
              // Like Button with Optional Click
              GestureDetector(
                onTap: widget.onLikeTap,
                child: widget.isLiked
                    ? SvgPicture.asset(
                        AppIcons.likedFillIcons,
                        height: 20,
                        width: 20,
                      )
                    : Icon(Icons.favorite_border_outlined, size: 20),
              ),
              Gap(width: 5),
              AppText(
                text: "${widget.likesCount}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamilyIndex: 2,
              ),
              Gap(width: 10),
              // Comment Button with Optional Click
              GestureDetector(
                onTap: widget.onCommentTap,
                child: Icon(Icons.comment_outlined, size: 20),
              ),
              Gap(width: 5),
              AppText(
                text: "${widget.commentsCount}",
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamilyIndex: 2,
              ),
              Gap(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
