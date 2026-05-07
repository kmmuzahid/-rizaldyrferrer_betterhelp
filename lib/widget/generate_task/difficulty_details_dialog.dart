import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/generate_task/domain_selection_dialog.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DifficultyDetailsDialog extends StatefulWidget {
  const DifficultyDetailsDialog({super.key, required this.difficultyDetails});

  final Map<String, String> difficultyDetails;

  @override
  State<DifficultyDetailsDialog> createState() =>
      _DifficultyDetailsDialogState();
}

class _DifficultyDetailsDialogState extends State<DifficultyDetailsDialog> {
  final GlobalKey _dialogKey = GlobalKey();
  late List<GlobalKey> _iconKeys;
  late List<TextEditingController> _textEditingControllers;

  String? activeTooltip;
  double? tooltipY;
  double? tooltipX;

  @override
  void initState() {
    super.initState();
    _textEditingControllers = List.generate(
      widget.difficultyDetails.length,
      (index) => TextEditingController(),
    );
    _iconKeys = List.generate(
      widget.difficultyDetails.length,
      (index) => GlobalKey(),
    );
  }

  void _showTooltip(String text, int index) {
    final RenderBox? iconBox =
        _iconKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? dialogBox =
        _dialogKey.currentContext?.findRenderObject() as RenderBox?;

    if (iconBox != null && dialogBox != null) {
      final position = iconBox.localToGlobal(Offset.zero, ancestor: dialogBox);
      setState(() {
        activeTooltip = text;
        tooltipY = position.dy + (iconBox.size.height / 2);
        tooltipX =
            (dialogBox.size.width - (position.dx + (iconBox.size.width / 2))) +
            9;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: () {
          if (activeTooltip != null) {
            setState(() {
              activeTooltip = null;
            });
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          key: _dialogKey,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F2),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text:
                          "In your own words, how do you experience these difficulties? Please be as specific as you can to ensure that the recommended strategies target your needs.",
                      fontFamilyIndex: 2,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF393433),
                      textAlign: TextAlign.center,
                      lineHeight: 1.4,
                      maxLines: 10,
                    ),
                    Gap(height: 24.h),
                    for (int i = 0; i < widget.difficultyDetails.length; i++)
                      _DifficultyInputField(
                        label: widget.difficultyDetails.keys.elementAt(i),
                        controller: _textEditingControllers[i],
                        iconKey: _iconKeys[i],
                        onInfoTap: () {
                          if (activeTooltip ==
                              widget.difficultyDetails.values.elementAt(i)) {
                            setState(() {
                              activeTooltip = null;
                            });
                          } else {
                            _showTooltip(
                              widget.difficultyDetails.values.elementAt(i),
                              i,
                            );
                          }
                        },
                      ),
                    Gap(height: 32.h),
                    _SubmitButton(
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (activeTooltip != null && tooltipY != null && tooltipX != null)
              DynamicTooltip(
                iconY: tooltipY!,
                iconX: tooltipX!,
                text: activeTooltip!,
              ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final GlobalKey iconKey;
  final VoidCallback onInfoTap;

  const _DifficultyInputField({
    required this.label,
    required this.controller,
    required this.iconKey,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                text: label,
                fontFamilyIndex: 1,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF393433),
                maxLines: 10,
                textAlign: TextAlign.left,
              ),
            ),
            const Gap(width: 8),
            GestureDetector(
              key: iconKey,
              onTap: onInfoTap,
              child: const Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFF393433),
              ),
            ),
          ],
        ),
        Gap(height: 8.h),
        Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF393433)),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.black, width: 1.5),
          shape: const StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: AppText(
          text: "Submit",
          fontFamilyIndex: 2,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF131927),
        ),
      ),
    );
  }
}
