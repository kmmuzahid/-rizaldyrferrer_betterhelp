import 'package:flutter/material.dart';

class TextSegment {
  final String text;
  final Color color;
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final Color? backgroundColor;

  TextSegment({
    required this.text,
    required this.color,
    required this.fontFamily,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.height = 1.0,
    this.letterSpacing,
    this.decoration,
    this.backgroundColor,
  });
}

class CustomRichText extends StatelessWidget {
  final List<TextSegment> segments;

  const CustomRichText({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: TextStyle(
              color: segment.color,
              fontSize: segment.fontSize,
              fontFamily: segment.fontFamily,
              fontWeight: segment.fontWeight,
              height: segment.height,
              letterSpacing: segment.letterSpacing,
              decoration: segment.decoration,
              backgroundColor: segment.backgroundColor,
            ),
          );
        }).toList(),
      ),
    );
  }
}