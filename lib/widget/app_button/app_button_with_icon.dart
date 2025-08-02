import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG icons

class IconAppButton extends StatelessWidget {
  const IconAppButton({
    super.key,
    this.height,
    this.width,
    this.alignment,
    this.child,
    this.decoration,
    this.onTap,
    this.padding,
    this.title,
    this.isLoading = false,
    this.loaderColor,
    this.margin,
    this.backgroundColor,
    this.loadingSize,
    this.titleColor,
    this.border,
    this.borderColor,
    this.icon, // Icon for button
    this.iconAlignment =
        CustomIconAlignment.left, // Default icon alignment is left
    this.iconSize = 24.0, // Default size for icon
    this.rowWidth, // Optional width for the row
    this.borderRadius,
    this.fontSize, // Optional font size for the button title
  });

  final double? loadingSize;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;
  final Widget? child;
  final String? title;
  final void Function()? onTap;
  final bool isLoading;
  final Color? titleColor;
  final Color? loaderColor;
  final Color? backgroundColor;
  final BoxBorder? border;
  final Color? borderColor;
  final String? icon; // Icon as SVG file path or asset
  final CustomIconAlignment iconAlignment; // Enum for icon alignment
  final double iconSize; // Size for the icon
  final double? rowWidth; // Optional width for the row
  final double? borderRadius; // Optional border radius for button
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
        width: width ?? double.infinity,
        // Make the button take full width if no width is provided
        height: height ?? 50,
        // Default height for the button
        alignment: alignment ?? Alignment.center,
        margin: margin,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration:
            decoration ??
            BoxDecoration(
              color: backgroundColor ?? AppColors.green500,
              // Button color
              border: borderColor != null
                  ? Border.all(color: borderColor!)
                  : null,
              borderRadius: BorderRadius.circular(
                borderRadius ?? 04.0,
              ), // Rounded corners
            ),
        child: isLoading
            ? SizedBox(
                width: loadingSize ?? 24.0,
                height: loadingSize ?? 24.0,
                child: CircularProgressIndicator(
                  color: loaderColor ?? AppColors.white50,
                ),
              )
            : Row(
                mainAxisAlignment: rowWidth == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween, // Center the elements
                children: [
                  if (icon != null && iconAlignment == CustomIconAlignment.left)
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: SvgPicture.asset(
                        icon!,
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                  // Text and the space between the text and the icon
                  AppText(
                    text: title ?? "",
                    color: titleColor ?? AppColors.white50,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize ?? 14.0,
                    fontFamilyIndex: 2,
                  ),
                  if (icon != null &&
                      iconAlignment == CustomIconAlignment.right)
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        icon!,
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                  // Add a SizedBox with a given width between the text and icon
                ],
              ),
      ),
    );
  }
}

// Enum for Custom Icon Alignment
enum CustomIconAlignment { left, right }
