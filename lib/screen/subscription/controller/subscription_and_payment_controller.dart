import 'package:better_help/utils/app_log/app_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionAndPaymentController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentPageIndex = 0.obs;
  final int totalPages = 5;

  //! Subscription plan names
  final List<String> planNames = [
    'Momentum',
    'Accelerate',
    'Elevate',
    'Ignite',
    'confirm Booking',
  ];

  //! Date selection for booking
  Rx<DateTime> selectedDate = DateTime.now().obs;

  //! Sample slots data - you can replace this with real data
  final Map<String, List<String>> slotsData = {
    'today': ['9:00 AM', '2:00 PM', '4:00 PM'],
    'tomorrow': ['10:00 AM', '3:00 PM'],
    'day_after_tomorrow': ['11:00 AM', '1:00 PM', '5:00 PM'],
    'yesterday': [], // No slots for past dates
    'default_future': [
      '9:00 AM',
      '11:00 AM',
      '2:00 PM',
      '4:00 PM',
    ], // Default slots for future dates
    'default_past': [], // No slots for past dates
  };

  void nextPage() {
    if (currentPageIndex.value < totalPages - 1) {
      currentPageIndex.value++;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPageIndex.value > 0) {
      currentPageIndex.value--;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index < totalPages) {
      currentPageIndex.value = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  String getCurrentPlanName() {
    return planNames[currentPageIndex.value];
  }

  void selectPlan() {
    // Handle plan selection logic
    appLog('Selected plan: ${getCurrentPlanName()}');
    // Navigate to payment or next screen
  }

  // Date selection methods
  void selectDate(DateTime date) {
    selectedDate.value = date;
    update(); // Trigger GetBuilder update
  }

  bool isDateSelected(DateTime date) {
    return selectedDate.value.day == date.day &&
        selectedDate.value.month == date.month &&
        selectedDate.value.year == date.year;
  }

  List<String> getSlotsForDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime dayAfterTomorrow = today.add(Duration(days: 2));
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (isSameDay(date, today)) {
      return slotsData['today'] ?? [];
    } else if (isSameDay(date, tomorrow)) {
      return slotsData['tomorrow'] ?? [];
    } else if (isSameDay(date, dayAfterTomorrow)) {
      return slotsData['day_after_tomorrow'] ?? [];
    } else if (isSameDay(date, yesterday)) {
      return slotsData['yesterday'] ?? [];
    } else if (date.isBefore(today)) {
      // Past dates - no slots available
      return slotsData['default_past'] ?? [];
    } else {
      // Future dates - default slots
      return slotsData['default_future'] ?? [];
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  String getDateDisplayText(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime yesterday = today.subtract(Duration(days: 1));

    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    String dayName = weekdays[date.weekday - 1];
    String monthName = months[date.month - 1];

    if (isSameDay(date, today)) {
      return '$dayName, ${date.day} $monthName';
    } else if (isSameDay(date, tomorrow)) {
      return '$dayName, ${date.day} $monthName';
    } else if (isSameDay(date, yesterday)) {
      return '$dayName, ${date.day} $monthName';
    }

    return '$dayName, ${date.day} $monthName';
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
