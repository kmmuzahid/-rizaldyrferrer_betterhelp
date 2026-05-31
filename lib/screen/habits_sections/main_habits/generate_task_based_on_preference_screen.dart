import 'package:better_help/screen/habits_sections/main_habits/controller/generate_task_based_on_preferense_controller.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/utils/app_size/app_gap.dart';
import 'package:better_help/widget/app_text/app_text.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetStringUtils;

class GenerateTaskBasedOnPreferenceScreen extends StatelessWidget {
  const GenerateTaskBasedOnPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GenerateTaskBasedOnPreferenceController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          text: "Generate a task based on your preferences",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100.h),
                        child: CircularProgressIndicator(
                          color: AppColors.primary300,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.aiTasks.length,
                      separatorBuilder: (context, index) => Gap(height: 20.h),
                      itemBuilder: (context, index) {
                        return _TaskCard(index: index);
                      },
                    ),
            ),
            Obx(
              () => controller.isLoading.value
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        CkButton(
                          onTap: () => controller.addTask(),
                          buttonColor: const Color(0xFFFF8D41),

                          titleText: "Add Task",
                          buttonWidth: 220,
                        ),

                        10.height,
                        CkButton(
                          onTap: () {
                            controller.regenerateTasks();
                          },
                          buttonColor: const Color(0xFF309AAD),
                          buttonWidth: 220,
                          titleText: "Regenerate Task",
                        ),
                      ],
                    ),
            ),
            Gap(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final int index;

  const _TaskCard({required this.index});

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onPicked,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF8D41),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> days = [
      "sunday",
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
    ];

    return GetBuilder<GenerateTaskBasedOnPreferenceController>(
      builder: (controller) {
        final task = controller.aiTasks[index];

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFEAECF0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValue(label: "Task Title", value: task.goal),
                Gap(height: 16.h),
                _LabelValue(label: "Task Description", value: task.task),
                Gap(height: 16.h),
                _LabelValue(label: "Target Domain", value: task.name),
                Gap(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: "Start Date",
                        date: _formatDate(task.startDate),
                        onTap: () => _selectDate(
                          context,
                          task.startDate,
                          (date) => controller.onDateChange(date, index, true),
                        ),
                      ),
                    ),
                    Gap(width: 16.w),
                    Expanded(
                      child: _DateField(
                        label: "End Date",
                        date: _formatDate(task.endDate),
                        onTap: () => _selectDate(
                          context,
                          task.endDate,
                          (date) => controller.onDateChange(date, index, false),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(height: 16.h),
                AppText(
                  text: "Schedule Type",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF393433),
                  fontFamilyIndex: 1,
                  textAlign: TextAlign.left,
                ),
                Gap(height: 8.h),
                Row(
                  children: [
                    _RadioOption(
                      label: "Daily",
                      isSelected: !task.isWeekly,
                      onTap: () => controller.onWeeklyChange(false, index),
                    ),
                    Gap(width: 24.w),
                    _RadioOption(
                      label: "Weekly",
                      isSelected: task.isWeekly,
                      onTap: () => controller.onWeeklyChange(true, index),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: task.isWeekly
                      ? Column(
                          key: const ValueKey("weekly_selector"),
                          children: [
                            Gap(height: 16.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 12.h,
                              children: List.generate(
                                days.length,
                                (idx) => _DayItem(
                                  label:
                                      days[idx]
                                          .substring(0, 3)
                                          .capitalizeFirst ??
                                      '',
                                  isSelected: task.days.contains(days[idx]),
                                  onTap: () =>
                                      controller.onDayChange(days[idx], index),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(key: ValueKey("daily_selector")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF393433),
          textAlign: TextAlign.left,
          fontFamilyIndex: 1,
        ),
        Gap(height: 4.h),
        AppText(
          text: value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF6D717F),
          textAlign: TextAlign.left,
          maxLines: 5,
          fontFamilyIndex: 2,
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String date;
  final VoidCallback onTap;
  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF393433),
          textAlign: TextAlign.left,
          fontFamilyIndex: 1,
        ),
        Gap(height: 8.h),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: date,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6D717F),
                  textAlign: TextAlign.left,
                  fontFamilyIndex: 2,
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18.sp,
                  color: const Color(0xFF6D717F),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : const Color(0xFFD2D5DB),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10.r,
                      height: 10.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  )
                : null,
          ),
          Gap(width: 8.w),
          AppText(
            text: label,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF393433),
            fontFamilyIndex: 2,
          ),
        ],
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18.r,
            height: 18.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: isSelected ? Colors.black : const Color(0xFFD2D5DB),
                width: 1,
              ),
              color: isSelected ? Colors.black : Colors.transparent,
            ),
            child: isSelected
                ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                : null,
          ),
          Gap(width: 6.w),
          AppText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6D717F),
            fontFamilyIndex: 2,
          ),
        ],
      ),
    );
  }
}
