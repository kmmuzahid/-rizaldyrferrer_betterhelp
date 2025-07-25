import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.textScaleFactor = 0.9,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.center,
    this.lineHeight = 1.5, // Renamed for clarity
    this.letterSpacing, // Added for letter spacing
    this.decoration,
    this.decorationColor,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.isTranslate = true,
    this.fontFamilyIndex = 1,
    this.isUnderlined = false,
  });

  final bool isTranslate;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final double? fontSize;
  final double textScaleFactor;
  final Color? color;
  final FontWeight? fontWeight;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final double lineHeight;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final int fontFamilyIndex;
  final bool isUnderlined;

  TextStyle _getFontStyle() {
    final effectiveDecoration = isUnderlined
        ? TextDecoration.underline
        : (decoration ?? TextDecoration.none);

    switch (fontFamilyIndex) {
      case 1:
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: lineHeight,
          letterSpacing: letterSpacing,
          decoration: effectiveDecoration,
          decorationColor: decorationColor,
        );
      case 2:
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: lineHeight,
          letterSpacing: letterSpacing,
          decoration: effectiveDecoration,
          decorationColor: decorationColor,
        );
      case 3:
        return GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: lineHeight,
          letterSpacing: letterSpacing,
          decoration: effectiveDecoration,
          decorationColor: decorationColor,
        );
      default:
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: lineHeight,
          letterSpacing: letterSpacing,
          decoration: effectiveDecoration,
          decorationColor: decorationColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: Text(
        isTranslate ? text.tr : text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: _getFontStyle(),
      ),
    );
  }
}