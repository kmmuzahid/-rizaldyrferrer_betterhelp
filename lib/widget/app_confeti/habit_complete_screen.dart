import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HabitCompleteScreen extends StatefulWidget {
  const HabitCompleteScreen({super.key});

  @override
  State<HabitCompleteScreen> createState() => _HabitCompleteScreenState();
}

// We use SingleTickerProviderStateMixin to provide the ticker for the AnimationController
class _HabitCompleteScreenState extends State<HabitCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _trophyScaleAnimation;
  late Animation<double> _trophyFadeAnimation;
  late Animation<double> _rotationAnimation;

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
    _rotationAnimation = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // The background gradient
        decoration: const BoxDecoration(color: Color(0xFFFFC148)),
        child: Stack(
          children: [
            // Layer 1: The animated rotating sunburst
            RotationTransition(
              turns: _rotationAnimation,
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
                const SizedBox(height: 500), // Space for the trophy container
                // The text content
                const AppText(
                  text: 'Congratulations!',
                  fontSize: 40,
                  fontFamilyIndex: 3,
                  fontWeight: FontWeight.w700,
                  lineHeight: 1.70,
                  color: Color(0xFFB24E00),
                  letterSpacing: -1,
                ),
                Gap(height: 15,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'You just completed your habit goal! This badge is a symbol of your commitment to yourself. Keep going and earn more badges along the way.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFA16C04),
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),

                // The "Next" button
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Restart the animation on tap for demo purposes
                      if (_controller.isCompleted) {
                        _controller.reset();
                        _controller.forward();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 20,
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
      ..color = Colors.white.withValues(alpha: 0.15)
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
