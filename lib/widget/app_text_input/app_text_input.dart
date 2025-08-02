import 'package:better_help/utils/app_size/app_size.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors/app_colors.dart';

class AppTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final double? borderRadius;
  final BorderSide? borderSide;
  final Color? borderColor;
  final bool isPassword;
  final IconData? prefixIcon;
  final Color? hintTextColor;
  final Color? textColor;
  final int? maxLines;
  final VoidCallback? onTapSuffix;

  const AppTextInput({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.height,
    this.width,
    this.backgroundColor,
    this.keyboardType,
    this.borderRadius,
    this.borderSide,
    this.borderColor,
    this.isPassword = false,
    this.prefixIcon,
    this.hintTextColor,
    this.textColor,
    this.maxLines,
    this.onTapSuffix,
  });

  @override
  State<AppTextInput> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<AppTextInput> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  double _calculateHeight() {
    final lines = widget.maxLines ?? 1;
    final baseHeight = widget.height ?? ResponsiveUtils.height(50);
    final lineHeight = ResponsiveUtils.height(20);

    return lines == 1 ? baseHeight : baseHeight + ((lines - 1) * lineHeight);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);

    return Container(
      height: widget.maxLines == null
          ? widget.height ?? ResponsiveUtils.height(50)
          : null,
      width: widget.width ?? double.infinity,
      constraints: widget.maxLines != null
          ? BoxConstraints(
              minHeight: widget.height ?? ResponsiveUtils.height(50),
              maxHeight: _calculateHeight(),
            )
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.borderColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        border: Border.all(
          color: widget.borderColor ?? AppColors.borderColor,
          width: widget.borderSide?.width ?? 1.0,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        maxLines: widget.maxLines ?? 1,
        style: TextStyle(
          color: widget.textColor ?? Colors.black,
          fontSize: ResponsiveUtils.width(14),
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.width(16),
            vertical: ResponsiveUtils.height(14),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintTextColor ?? AppColors.hintTextColor,
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveUtils.width(14),
            letterSpacing: -0.27,
            height: 1.60,
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: widget.hintTextColor ?? AppColors.hintTextColor,
                  size: ResponsiveUtils.width(20),
                )
              : null,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: widget.onTapSuffix ??
                      () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: widget.hintTextColor ?? AppColors.hintTextColor,
                    size: ResponsiveUtils.width(20),
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}