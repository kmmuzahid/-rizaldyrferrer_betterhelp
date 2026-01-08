import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';

enum CardType { course, article }

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String instructor;
  final double? rating;
  final String? views;
  final String? date;
  final String? timeToread;
  final CardType cardType;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorited;
  final double? width;
  final EdgeInsets? margin;
  final double? height;

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.instructor,
    this.rating,
    this.views,
    this.date,
    this.timeToread,
    this.cardType = CardType.course,
    this.onTap,
    this.onFavoritePressed,
    this.isFavorited = false,
    this.width,
    this.margin,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Use custom height if provided, otherwise use default based on card type
    double cardHeight =
        height ??
        (cardType == CardType.article
            ? AppSize.height(value: 230) // Default height for articles
            : AppSize.height(value: 200)); // Default height for courses
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.t5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Flexible(child: _buildContentSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: imageUrl.isNotEmpty && imageUrl != "imageUrl"
              ? (imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        height: AppSize.height(value: 120),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: AppSize.height(value: 120),
                            width: double.infinity,
                            color: AppColors.t5,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary500,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        imageUrl,
                        height: AppSize.height(value: 120),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      ))
              : _buildPlaceholderImage(),
        ),
        _buildFavoriteButton(),
        _buildViewsCounter(),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    IconData iconData;
    Color iconColor;

    // Proper CardType handling
    switch (cardType) {
      case CardType.course:
        iconData = isFavorited ? Icons.favorite : Icons.favorite_border;
        iconColor = isFavorited ? Colors.red : Colors.white;
        break;
      case CardType.article:
        iconData = isFavorited ? Icons.bookmark : Icons.bookmark_border;
        iconColor = isFavorited ? Colors.blue : Colors.white;
        break;
    }

    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: onFavoritePressed,
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: iconColor, size: 18),
        ),
      ),
    );
  }

  Widget _buildViewsCounter() {
    // Different display based on card type
    String displayText = '';
    switch (cardType) {
      case CardType.course:
        displayText =
            views ?? '0 views'; // Show views for courses with fallback
        break;
      case CardType.article:
        displayText =
            timeToread ??
            '0 min read'; // Show reading time for articles with fallback
        break;
    }

    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AppText(
          text: displayText,
          fontSize: AppSize.width(value: 12),
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamilyIndex: 2,
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          Gap(height: 4),
          _buildInstructor(),
          Gap(height: 8),
          _buildFooterSection(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return AppText(
      text: title,
      fontSize: AppSize.width(value: 14),
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryBlack,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      fontFamilyIndex: 2,
    );
  }

  Widget _buildInstructor() {
    // Different label based on card type
    String displayText = '';
    switch (cardType) {
      case CardType.course:
        // Show instructor for courses
        displayText = instructor;
        break;
      case CardType.article:
        // Show author for articles
        displayText = 'By $instructor';
        break;
    }

    return AppText(
      text: displayText,
      fontSize: AppSize.width(value: 12),
      color: AppColors.grey500,
      fontWeight: FontWeight.w500,
      fontFamilyIndex: 2,
    );
  }

  Widget _buildFooterSection() {
    // Different footer based on card type
    switch (cardType) {
      case CardType.course:
        return _buildCourseFooter();
      case CardType.article:
        return _buildArticleFooter();
    }
  }

  Widget _buildCourseFooter() {
    return Row(
      children: [
        _buildStarRating(),
        Gap(width: 4),
        _buildRatingText(),
        Spacer(),
        AppText(
          // Date with fallback
          text: date ?? 'No date',
          fontSize: AppSize.width(value: 12),
          color: AppColors.grey500,
          fontWeight: FontWeight.w400,
          fontFamilyIndex: 2,
        ),
      ],
    );
  }

  Widget _buildArticleFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: views ?? '0 views', // Views count for articles with fallback
          fontSize: AppSize.width(value: 12),
          color: AppColors.grey500,
          fontWeight: FontWeight.w500,
          fontFamilyIndex: 2,
        ),
        AppText(
          text: date ?? 'No date', // Date with fallback
          fontSize: AppSize.width(value: 12),
          color: AppColors.grey500,
          fontWeight: FontWeight.w500,
          fontFamilyIndex: 2,
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    final double currentRating = rating ?? 0.0;
    return Row(
      children: List.generate(5, (starIndex) {
        return Icon(
          starIndex < currentRating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildRatingText() {
    final double currentRating = rating ?? 0.0;
    return AppText(
      text: currentRating.toStringAsFixed(1),
      fontSize: AppSize.width(value: 14),
      color: AppColors.grey500,
      fontWeight: FontWeight.w500,
      fontFamilyIndex: 2,
    );
  }

  Widget _buildPlaceholderImage() {
    // Different placeholder based on card type
    IconData placeholderIcon;
    String placeholderText;

    switch (cardType) {
      case CardType.course:
        placeholderIcon = Icons.play_circle_outline;
        placeholderText = "No Course Image";
        break;
      case CardType.article:
        placeholderIcon = Icons.article_outlined;
        placeholderText = "No Article Image";
        break;
    }

    return Container(
      height: AppSize.height(value: 140),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.t5,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(placeholderIcon, size: 48, color: AppColors.grey400),
          Gap(height: 8),
          AppText(
            text: placeholderText,
            fontSize: AppSize.width(value: 14),
            color: AppColors.grey400,
            fontWeight: FontWeight.w500,
            fontFamilyIndex: 2,
          ),
        ],
      ),
    );
  }
}
