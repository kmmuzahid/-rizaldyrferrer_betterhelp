import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';

class AppLoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoadingWidget({super.key, this.size = 50, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: color ?? AppColors.primary500,
        size: size,
      ),
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const AppLoadingOverlay({
    super.key,
    this.message,
    this.size = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.threeArchedCircle(
              color: color ?? AppColors.primary500,
              size: size,
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
