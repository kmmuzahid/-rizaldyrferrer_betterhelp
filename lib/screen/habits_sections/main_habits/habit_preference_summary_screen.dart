import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/generate_task/domain_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;

class HabitPreferenceSummaryScreen extends StatefulWidget {
  const HabitPreferenceSummaryScreen({super.key});

  @override
  State<HabitPreferenceSummaryScreen> createState() =>
      _HabitPreferenceSummaryScreenState();
}

class _HabitPreferenceSummaryScreenState
    extends State<HabitPreferenceSummaryScreen> {
  final GlobalKey _stackKey = GlobalKey();
  late Map<String, String> difficultyDetails;
  late List<TextEditingController> _textEditingControllers;
  late List<GlobalKey> _iconKeys;

  String? activeTooltip;
  double? tooltipY;
  double? tooltipX;

  @override
  void initState() {
    super.initState();
    difficultyDetails = Map<String, String>.from(Get.arguments ?? {});
    _textEditingControllers = List.generate(
      difficultyDetails.length,
      (index) => TextEditingController(),
    );
    _iconKeys = List.generate(difficultyDetails.length, (index) => GlobalKey());
  }

  void _showTooltip(String text, int index) {
    final RenderBox? iconBox =
        _iconKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? stackBox =
        _stackKey.currentContext?.findRenderObject() as RenderBox?;

    if (iconBox != null && stackBox != null) {
      final position = iconBox.localToGlobal(Offset.zero, ancestor: stackBox);
      setState(() {
        activeTooltip = text;
        tooltipY = position.dy + (iconBox.size.height / 2);
        tooltipX =
            (stackBox.size.width - (position.dx + (iconBox.size.width / 2))) +
            9;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          text: "Generate Strategy",
          fontFamilyIndex: 1,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF393433),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        centerTitle: true,
        toolbarHeight: 80.h,
      ),
      body: GestureDetector(
        onTap: () {
          if (activeTooltip != null) {
            setState(() {
              activeTooltip = null;
            });
          }
        },
        behavior: HitTestBehavior.opaque,
        child: CkFormBuilder(
          entity: null,
          builder: (context, formKey, entity) => Stack(
            key: _stackKey,
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
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
                    for (int i = 0; i < difficultyDetails.length; i++) ...[
                      _DifficultyInputField(
                        label: difficultyDetails.keys.elementAt(i),
                        controller: _textEditingControllers[i],
                        iconKey: _iconKeys[i],
                        onInfoTap: () {
                          if (activeTooltip ==
                              difficultyDetails.values.elementAt(i)) {
                            setState(() {
                              activeTooltip = null;
                            });
                          } else {
                            _showTooltip(
                              difficultyDetails.values.elementAt(i),
                              i,
                            );
                          }
                        },
                      ),
                      Gap(height: 20.h),
                    ],
                    Gap(height: 12.h),
                    CkButton(
                      onTap: () {
                        if (formKey.validateAndSave()) {
                          if (_textEditingControllers.any(
                            (element) => element.text.isEmpty,
                          )) {
                            return;
                          }
                          List<Map<String, String>> tasksData = [
                            for (int i = 0; i < difficultyDetails.length; i++)
                              {
                                'name': difficultyDetails.keys.elementAt(i),
                                'definition': difficultyDetails.values
                                    .elementAt(i),
                                'userText': _textEditingControllers[i].text,
                              },
                          ];
                          Get.toNamed(
                            AppRoute.generateTaskBasedOnPreference,
                            arguments: tasksData,
                          );
                        }
                      },
                      buttonColor: const Color(0xFFFF8D41),
                      titleText: "Submit",
                      buttonWidth: 220,
                    ),
                    Gap(height: 30.h),
                  ],
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
        CkMultilineTextField(
          controller: controller,
          backgroundColor: Colors.white,
          height: 100,
          validationType: CkValidationType.validateRequired,
        ),
      ],
    );
  }
}
