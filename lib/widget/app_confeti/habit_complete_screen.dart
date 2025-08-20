import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_button/app_button.dart';
import 'package:better_help/widget/app_confeti/controller/congratulaiton_screen_controller.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({super.key});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

// We use SingleTickerProviderStateMixin to provide the ticker for the AnimationController
class _CongratulationScreenState extends State<CongratulationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _trophyScaleAnimation;
  late Animation<double> _trophyFadeAnimation;
  late AnimationController _rotationAnimationController;
  final controller = Get.put(CongratulaitonScreenController());

  @override
  void initState() {
    super.initState();

    // The main controller for all animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Animation for the main badge scaling up
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // A bouncy effect
    );

    // Animation for the trophy scaling up (starts after 30% of the time)
    _trophyScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Animation for the trophy fading in (starts after 30% of the time)
    _trophyFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    // Animation for the sunburst rotation
    _rotationAnimationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // The background gradient
        decoration: const BoxDecoration(color: Color(0xFF4E61F6)),
        child: Stack(
          children: [
            // Layer 1: The animated rotating sunburst
            RotationTransition(
              turns: _rotationAnimationController,
              child: CustomPaint(
                painter: SunburstPainter(),
                child: Container(),
              ),
            ),

            // Layer 2: Trophy container positioned at screen center
            Positioned.fill(
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      width: AppSize.width(value: 170),
                      height: AppSize.height(value: 200),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppStaticImages.pentagon),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // Layer 3: The trophy animation, inside the badge
                      child: FadeTransition(
                        opacity: _trophyFadeAnimation,
                        child: ScaleTransition(
                          scale: _trophyScaleAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Image.asset(AppStaticImages.winner),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Layer 3: Text content and button positioned at top and bottom
            Column(
              children: [
                const Spacer(),
                const Gap(height: 500), // Space for the trophy container
                // The text content
                const AppText(
                  text: 'Congratulations!',
                  fontSize: 40,
                  fontFamilyIndex: 3,
                  fontWeight: FontWeight.w700,
                  lineHeight: 1.70,
                  color: AppColors.white,
                  letterSpacing: -1,
                ),
                Gap(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: AppText(
                    text: 'You just completed your habit goal!',
                    textAlign: TextAlign.center,
                    fontSize: AppSize.width(value: 24),
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontFamilyIndex: 4,
                    lineHeight: 1.5,
                  ),
                ),
                Gap(height: 05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: AppText(
                    text:
                        ' This badge is a symbol of your commitment to yourself. Keep going and earn more badges along the way.',
                    textAlign: TextAlign.center,
                    fontSize: AppSize.width(value: 14),
                    color: AppColors.white,
                    maxLines: 4,
                    fontWeight: FontWeight.w500,
                    fontFamilyIndex: 4,
                    overflow: TextOverflow.ellipsis,
                    lineHeight: 1.5,
                  ),
                ),
                const Spacer(),

                // The "Next" button
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AppSize.height(value: 50),
                    left: AppSize.width(value: 25),
                    right: AppSize.width(value: 25),
                  ),
                  child: AppButton(
                    title: "Next",
                    titleColor: AppColors.black,
                    backgroundColor: AppColors.white,
                    borderradius: 15,
                    onTap: () {
                      // Navigate back to the previous screen
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// This custom painter draws the sunburst rays
class SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 2.5;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    const int rayCount = 08;
    const double angle = 2 * math.pi / rayCount;

    for (int i = 0; i < rayCount; i++) {
      final path = Path();
      // Move to the center
      path.moveTo(center.dx, center.dy);
      // Draw a triangular ray
      path.lineTo(
        center.dx + radius * math.cos(angle * i - (angle / 4)),
        center.dy + radius * math.sin(angle * i - (angle / 4)),
      );
      path.lineTo(
        center.dx + radius * math.cos(angle * i + (angle / 4)),
        center.dy + radius * math.sin(angle * i + (angle / 4)),
      );
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
