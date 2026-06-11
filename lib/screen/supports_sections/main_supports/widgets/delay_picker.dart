import 'dart:math' as math;

import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class DelayPicker extends StatefulWidget {
  const DelayPicker({super.key, required this.onSelect});
  final void Function(int) onSelect;

  @override
  State<DelayPicker> createState() => _DelayPickerState();
}

class _DelayPickerState extends State<DelayPicker> {
  int selectedMinutes = 5;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText(
              text: 'Select Delay',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            4.height,
            const AppText(
              text: 'Choose minutes to delay the message',
              fontSize: 12,
              fontFamilyIndex: 2,
              color: AppColors.hintTextColor,
            ),
            30.height,
            SizedBox(
              height: 240,
              width: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The hand (dialer)
                  Transform.rotate(
                    angle:
                        (selectedMinutes == 60 ? 0 : selectedMinutes / 5) *
                        (math.pi / 6),
                    child: Container(
                      height:
                          180, // slightly shorter than 200 (diameter of numbers)
                      width: 4,
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 90,
                        width: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Center dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Clock face numbers
                  ...List.generate(12, (clockIndex) {
                    final displayValue = clockIndex == 0 ? 60 : clockIndex * 5;
                    final angle = (clockIndex * 30 - 90) * (math.pi / 180);
                    final radius = 100.0;
                    final x = radius * math.cos(angle);
                    final y = radius * math.sin(angle);

                    final isSelected = selectedMinutes == displayValue;

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMinutes = displayValue;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? 48 : 44,
                          height: isSelected ? 48 : 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary300
                                : AppColors.blue50,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary300.withOpacity(
                                isSelected ? 1.0 : 0.3,
                              ),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary300.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            text: '$displayValue',
                            fontSize: isSelected ? 16 : 14,
                            fontFamilyIndex: 2,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primary300,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            30.height,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: AppColors.primary300),
                    ),
                    child: const AppText(
                      text: 'Cancel',
                      color: AppColors.primary300,
                      fontFamilyIndex: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSelect.call(selectedMinutes);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const AppText(
                      text: 'Confirm',
                      color: AppColors.white,
                      fontFamilyIndex: 2,
                      fontWeight: FontWeight.bold,
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
