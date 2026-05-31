import 'dart:math' as math;

import 'package:better_help/widget/app_appbar/appbar_only_logo.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/utils/ck_screen_utils.dart';
import 'package:flutter/material.dart';

class AnalyzingScreen extends StatelessWidget {
  const AnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 1. The Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFDE08D), // Light Yellow/Orange
              Color(0xFFFE9D52), // Vibrant Orange
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  // 3. Header Text
                  AppBarOnlyLogo(),

                  const Spacer(),

                  // 4. "Analyzing" Text
                  const AppText(
                    text: "Analyzing",
                    fontSize: 40,
                    fontFamilyIndex: 1, // Matches the serif style in image
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 40),

                  // 5. Custom Infinity Loader
                  SizedBox(
                    width: 140.h,
                    height: 140.h,
                    child: InfinityLoader(color: Color(0xFFff924d)),
                  ),
                  72.height,
                  // 6. Footer Text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Please wait while we analyze your responses.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Color(0xFF1B3B36), height: 1.5),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfinityLoader extends StatefulWidget {
  final Color color;
  const InfinityLoader({super.key, required this.color});

  @override
  State<InfinityLoader> createState() => _InfinityLoaderState();
}

class _InfinityLoaderState extends State<InfinityLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CircularProgressPainter(progress: _controller.value, color: widget.color),
        );
      },
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Background Track (The faint orange circle)
    final trackPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          20 // Thickness of the track
      ..strokeCap = StrokeCap.round;

    // 2. The White Border (Drawn slightly thicker than the orange part)
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          24 // 4px wider than the orange bar to create the border
      ..strokeCap = StrokeCap.round;

    // 3. The Active Orange Bar
    final activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    // Animation Logic
    // Start angle rotates over time, Sweep angle is about 75% of the circle
    double startAngle = -math.pi / 2 + (progress * 2 * math.pi);
    double sweepAngle = 1.5 * math.pi; // Controls how "long" the bar is

    // Draw the track
    canvas.drawCircle(center, radius, trackPaint);

    // Draw the white border first
    canvas.drawArc(rect, startAngle, sweepAngle, false, borderPaint);

    // Draw the orange bar on top
    canvas.drawArc(rect, startAngle, sweepAngle, false, activePaint);
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) => true;
}
