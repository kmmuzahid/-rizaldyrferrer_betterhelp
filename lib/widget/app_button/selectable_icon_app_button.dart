import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG icons

class SelectableIconAppButton extends StatefulWidget {
  const SelectableIconAppButton({
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
    this.horizontalPadding,
    this.verticalPadding,
    this.titleColor,
    this.border,
    this.borderColor,
    this.icon, // Icon for button (SVG or PNG asset path)
    this.iconAlignment =
        CustomIconAlignment.left, // Default icon alignment is left
    this.iconSize = 24.0, // Default size for icon
    this.rowWidth, // Optional width for the row
    this.borderRadius,
    this.fontSize, // Optional font size for the button title
    this.iconColor, // Color for SVG icons (doesn't affect PNG)
    this.initiallySelected = false, // Initial selection state
    this.selectedBackgroundColor, // Background color when selected
    this.selectedTitleColor, // Title color when selected
    this.selectedIconColor, // Icon color when selected
    this.selectedBorderColor, // Border color when selected
    this.animationDuration = const Duration(
      milliseconds: 300,
    ), // Animation duration
    this.onSelectionChanged, // Callback when selection changes
  });

  final double? loadingSize;
  final double? width;
  final double? height;
  final double? horizontalPadding;
  final double? verticalPadding;
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
  final String? icon; // Icon as SVG or PNG file path or asset
  final CustomIconAlignment iconAlignment; // Enum for icon alignment
  final double iconSize; // Size for the icon
  final double? rowWidth; // Optional width for the row
  final double? borderRadius; // Optional border radius for button
  final double? fontSize;
  final Color? iconColor; // Color for SVG icons

  // Selection state properties
  final bool initiallySelected;
  final Color? selectedBackgroundColor;
  final Color? selectedTitleColor;
  final Color? selectedIconColor;
  final Color? selectedBorderColor;
  final Duration animationDuration;
  final void Function(bool isSelected)?
  onSelectionChanged; // Callback for selection changes

  @override
  // ignore: library_private_types_in_public_api
  _SelectableIconAppButtonState createState() =>
      _SelectableIconAppButtonState();
}

class _SelectableIconAppButtonState extends State<SelectableIconAppButton> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
  }

  void _handleTap() {
    if (widget.isLoading) return;

    setState(() {
      isSelected = !isSelected;
    });

    // Call the selection changed callback
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(isSelected);
    }

    // Call the original onTap callback if provided
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  // Helper method to determine if the icon is SVG or PNG
  bool _isSvgIcon(String iconPath) {
    return iconPath.toLowerCase().endsWith('.svg');
  }

  // Helper method to build the appropriate icon widget
  Widget _buildIconWidget(String iconPath) {
    Color? currentIconColor = isSelected
        ? (widget.selectedIconColor ?? widget.iconColor)
        : widget.iconColor;

    if (_isSvgIcon(iconPath)) {
      // SVG Icon
      return SvgPicture.asset(
        iconPath,
        width: widget.iconSize,
        height: widget.iconSize,
        colorFilter: currentIconColor != null
            ? ColorFilter.mode(currentIconColor, BlendMode.srcIn)
            : null,
      );
    } else {
      // PNG/Image Icon
      return Image.asset(
        iconPath,
        width: widget.iconSize,
        height: widget.iconSize,
        fit: BoxFit.contain,
      );
    }
  }

  // Get current background color based on selection state
  Color _getCurrentBackgroundColor() {
    if (isSelected) {
      return widget.selectedBackgroundColor ??
          AppColors.green700; // Darker green when selected
    }
    return widget.backgroundColor ?? AppColors.green500;
  }

  // Get current title color based on selection state
  Color _getCurrentTitleColor() {
    if (isSelected) {
      return widget.selectedTitleColor ??
          widget.titleColor ??
          AppColors.white50;
    }
    return widget.titleColor ?? AppColors.white50;
  }

  // Get current border color based on selection state
  Color? _getCurrentBorderColor() {
    if (isSelected) {
      return widget.selectedBorderColor ?? widget.borderColor;
    }
    return widget.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.ease,
        width: widget.width ?? double.infinity,
        height: widget.height ?? 50,
        alignment: widget.alignment ?? Alignment.center,
        margin: widget.margin,
        padding:
            widget.padding ??
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration:
            widget.decoration ??
            BoxDecoration(
              color: _getCurrentBackgroundColor(),
              border: _getCurrentBorderColor() != null
                  ? Border.all(color: _getCurrentBorderColor()!)
                  : null,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.0),
              // Add subtle shadow when selected
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
        child: widget.isLoading
            ? SizedBox(
                width: widget.loadingSize ?? 24.0,
                height: widget.loadingSize ?? 24.0,
                child: CircularProgressIndicator(
                  color: widget.loaderColor ?? AppColors.white50,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null &&
                      widget.iconAlignment == CustomIconAlignment.left)
                    Padding(
                      padding: EdgeInsets.only(right: 6.0),
                      child: _buildIconWidget(widget.icon!),
                    ),
                  AppText(
                    text: widget.title ?? "",
                    color: _getCurrentTitleColor(),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400, // Bold when selected
                    fontSize: widget.fontSize ?? 14.0,
                    fontFamilyIndex: 2,
                  ),
                  if (widget.icon != null &&
                      widget.iconAlignment == CustomIconAlignment.right)
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: _buildIconWidget(widget.icon!),
                    ),
                ],
              ),
      ),
    );
  }
}

// Enum for Custom Icon Alignment
enum CustomIconAlignment { left, right }
