import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/utils/app_size/app_size.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/widget/generate_task/difficulty_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DomainSelectionDialog extends StatefulWidget {
  const DomainSelectionDialog({super.key});

  @override
  State<DomainSelectionDialog> createState() => _DomainSelectionDialogState();
}

class _DomainSelectionDialogState extends State<DomainSelectionDialog> {
  final GlobalKey _dialogKey = GlobalKey();
  final List<GlobalKey> iconKeys = List.generate(8, (index) => GlobalKey());

  final Map<String, String> domainDescriptions = {
    "Executive Inhibition (Self-Restraint)":
        "I talk over others or say too much during conversations. I am pacing or shifting around, even when I know I should stay still. When I try to focus, my own irrelevant thoughts or things around distract me. I make decisions about things like money, work, or relationships before considering the consequences. My attention jumps from one thing to another, and it’s hard to get back on track.",
    "Goal-Directed Persistence (Self-Motivation)":
        "It’s hard to keep going on a task, even if they’re important to me.",
    "Planning and Problem-Solving":
        "I get stuck when things don’t go as planned and don’t know how to adjust.",
    "Self-Awareness (Meta-Cognition)":
        "I don’t notice when I’m off-task or making mistakes.",
    "Verbal Working Memory":
        "I forget what I want to say or do unless I write it down.",
    "Non-Verbal Working Memory":
        "I forget where I put things or what I was about to do.",
    "Emotional Dysregulation":
        "I struggle to calm myself down once a strong emotion starts.",
    "Other Areas (General Life Management)":
        "I have a hard time keeping up with things like my space, health, or relationships.",
  };

  final List<String> selectedDomains = [];
  String? activeTooltip;
  int? activeTooltipIndex;
  double? tooltipY;
  double? tooltipX;

  void toggleDomain(String domain) {
    setState(() {
      if (selectedDomains.contains(domain)) {
        selectedDomains.remove(domain);
      } else {
        if (selectedDomains.length < 3) {
          selectedDomains.add(domain);
        }
      }
    });
  }

  void _showTooltip(String domain, int index) {
    final RenderBox? iconBox =
        iconKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? dialogBox =
        _dialogKey.currentContext?.findRenderObject() as RenderBox?;

    if (iconBox != null && dialogBox != null) {
      final position = iconBox.localToGlobal(Offset.zero, ancestor: dialogBox);
      setState(() {
        activeTooltip = domain;
        activeTooltipIndex = index;
        tooltipY = position.dy + (iconBox.size.height / 2);
        tooltipX =
            (dialogBox.size.width - (position.dx + (iconBox.size.width / 2))) +
            9;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
      child: GestureDetector(
        onTap: () {
          if (activeTooltip != null) {
            setState(() {
              activeTooltip = null;
              activeTooltipIndex = null;
            });
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          key: _dialogKey,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 20),
                vertical: AppSize.height(value: 30),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD6CDEB),
                borderRadius: BorderRadius.circular(AppSize.width(value: 20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "8 Domains of Life\nManagement Difficulties",
                    fontFamilyIndex: 1,
                    fontSize: AppSize.width(value: 26),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF393433),
                    lineHeight: 1.2,
                  ),
                  Gap(height: AppSize.height(value: 8)),
                  AppText(
                    text: "Choose up to 3",
                    fontFamilyIndex: 2,
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF393433),
                  ),
                  Gap(height: AppSize.height(value: 24)),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: domainDescriptions.length,
                      separatorBuilder: (context, index) =>
                          const Gap(height: 16),
                      itemBuilder: (context, index) {
                        final domain = domainDescriptions.keys.elementAt(index);
                        final isSelected = selectedDomains.contains(domain);
                        return _buildDomainItem(domain, isSelected, index);
                      },
                    ),
                  ),
                  Gap(height: AppSize.height(value: 32)),
                  _buildNextButton(),
                ],
              ),
            ),
            if (activeTooltip != null && tooltipY != null && tooltipX != null)
              _buildTooltip(),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainItem(String domain, bool isSelected, int index) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (activeTooltip != null) {
              setState(() {
                activeTooltip = null;
                activeTooltipIndex = null;
              });
            }
            toggleDomain(domain);
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6D717F).withOpacity(0.5),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(2),
                  color: isSelected
                      ? const Color(0xFF393433)
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const Gap(width: 12),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => toggleDomain(domain),
            child: AppText(
              text: domain,
              fontFamilyIndex: 2,
              fontSize: AppSize.width(value: 13),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF545454),
              textAlign: TextAlign.left,
              maxLines: 10,
            ),
          ),
        ),
        GestureDetector(
          key: iconKeys[index],
          onTap: () {
            if (activeTooltip == domain) {
              setState(() {
                activeTooltip = null;
                activeTooltipIndex = null;
              });
            } else {
              _showTooltip(domain, index);
            }
          },
          child: const Icon(
            Icons.info_outline,
            size: 18,
            color: Color(0xFF393433),
          ),
        ),
      ],
    );
  }

  Widget _buildTooltip() {
    return DynamicTooltip(
      iconY: tooltipY!,
      iconX: tooltipX!,
      text: domainDescriptions[activeTooltip!]!,
    );
  }

  Widget _buildNextButton() {
    return InkWell(
      onTap: () {
        if (selectedDomains.isNotEmpty) {
          Get.back();
          Get.dialog(
            DifficultyDetailsDialog(
              difficultyDetails: getSelectedDifficulties(),
            ),
          );
        }
      },
      child: Container(
        width: AppSize.width(value: 160),
        padding: EdgeInsets.symmetric(vertical: AppSize.height(value: 12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.width(value: 30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppText(
          text: "Next",
          fontFamilyIndex: 2,
          fontSize: AppSize.width(value: 20),
          fontWeight: FontWeight.w700,
          color: selectedDomains.isNotEmpty
              ? const Color(0xFF131927)
              : const Color(0xFF131927).withOpacity(0.5),
        ),
      ),
    );
  }

  Map<String, String> getSelectedDifficulties() {
    Map<String, String> difficulties = {};
    for (var domain in selectedDomains) {
      difficulties[domain] = domainDescriptions[domain]!;
    }
    return difficulties;
  }
}

class DynamicTooltip extends StatefulWidget {
  final double iconY;
  final double iconX;
  final String text;

  const DynamicTooltip({
    super.key,
    required this.iconY,
    required this.iconX,
    required this.text,
  });

  @override
  State<DynamicTooltip> createState() => _DynamicTooltipState();
}

class _DynamicTooltipState extends State<DynamicTooltip> {
  final GlobalKey _bubbleKey = GlobalKey();
  double _bubbleHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _bubbleKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && mounted) {
        setState(() {
          _bubbleHeight = box.size.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const double minTop = 10.0;
    final double maxBottom = screenHeight - 100.0;

    double idealTop = widget.iconY - (_bubbleHeight / 2);
    double clampedTop = idealTop.clamp(minTop, maxBottom - _bubbleHeight);
    double triangleYLocal = (widget.iconY - clampedTop).clamp(0, _bubbleHeight);

    return Positioned(
      top: clampedTop,
      right: widget.iconX,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            key: _bubbleKey,
            constraints: BoxConstraints(maxWidth: AppSize.width(value: 240)),
            child: CustomPaint(
              painter: _BubblePainter(
                triangleY: triangleYLocal,
                color: Colors.white,
                borderColor: const Color(0xFFD2D5DB),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: AppText(
                  text: widget.text,
                  fontFamilyIndex: 2,
                  fontSize: AppSize.width(value: 12),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF393433),
                  textAlign: TextAlign.center,
                  maxLines: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final double triangleY;
  final Color color;
  final Color borderColor;

  _BubblePainter({
    required this.triangleY,
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 12.0;
    const triangleWidth = 10.0;
    const triangleHeight = 12.0;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Radius cancellation logic
    double trRadius = triangleY < radius ? 0 : radius;
    double brRadius = triangleY > size.height - radius ? 0 : radius;

    final path = Path();

    // Start from top-left
    path.moveTo(radius, 0);

    // Top edge
    path.lineTo(size.width - trRadius, 0);

    // Top-right corner
    if (trRadius > 0) {
      path.arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      );
    } else {
      path.lineTo(size.width, 0);
    }

    // Right edge with triangle logic
    // Point 1: start of triangle
    path.lineTo(
      size.width,
      (triangleY - triangleHeight / 2).clamp(0, size.height),
    );
    // Point 2: tip of triangle
    path.lineTo(size.width + triangleWidth, triangleY);
    // Point 3: end of triangle
    path.lineTo(
      size.width,
      (triangleY + triangleHeight / 2).clamp(0, size.height),
    );

    // Bottom-right corner
    path.lineTo(size.width, size.height - brRadius);
    if (brRadius > 0) {
      path.arcToPoint(
        Offset(size.width - radius, size.height),
        radius: const Radius.circular(radius),
      );
    } else {
      path.lineTo(size.width, size.height);
    }

    // Bottom edge
    path.lineTo(radius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
    );

    // Left edge
    path.lineTo(0, radius);

    // Top-left corner
    path.arcToPoint(Offset(radius, 0), radius: const Radius.circular(radius));

    path.close();

    // Subtle shadow
    canvas.drawShadow(
      path.shift(const Offset(0, 2)),
      Colors.black.withOpacity(0.2),
      6,
      true,
    );

    // Main fill and border
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) =>
      oldDelegate.triangleY != triangleY;
}
