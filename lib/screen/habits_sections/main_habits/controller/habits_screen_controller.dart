import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class HabitsScreenController extends GetxController {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentIndex = 0.obs;
  var selectedDate = DateTime.now().obs;
  var checklistStates = <bool>[false, false, false].obs;

  // Quote data
  List<String> get quoteList => [
    AppString.quotes01,
    AppString.quotes02,
    AppString.quotes03,
    AppString.quotes04,
  ];

  List<String> get quoteAuthorList => [
    AppString.quotes01Author,
    AppString.quotes02Author,
    AppString.quotes03Author,
    AppString.quotes04Author,
  ];

  List<String> get backgroundImages => [
    AppStaticImages.habits01,
    AppStaticImages.habits02,
    AppStaticImages.habits03,
    AppStaticImages.habits04,
  ];

  // Method to update current index
  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  // Method to go to specific slide
  void goToSlide(int index) {
    carouselController.animateToPage(index);
  }

  // Method to go to next slide
  void nextSlide() {
    carouselController.nextPage();
  }

  // Method to go to previous slide
  void previousSlide() {
    carouselController.previousPage();
  }

  // Method to update selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Method to update checklist state
  void updateChecklistState(int index, bool value) {
    if (index >= 0 && index < checklistStates.length) {
      checklistStates[index] = value;
    }
  }

  // Method to get checklist completion percentage
  double get checklistProgress {
    if (checklistStates.isEmpty) return 0.0;
    int completedItems = checklistStates.where((state) => state).length;
    return completedItems / checklistStates.length;
  }

  // Generate schedule data for entire month
  Map<String, List<Map<String, dynamic>>> get scheduleData {
    Map<String, List<Map<String, dynamic>>> monthlySchedules = {};

    // Get current month details
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // Generate schedules for each day of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      DateTime currentDate = DateTime(now.year, now.month, day);
      String dateKey = _formatDate(currentDate);

      monthlySchedules[dateKey] = _generateSchedulesForDay(day);
    }

    return monthlySchedules;
  }

  // Generate 3 varied schedules for each day
  List<Map<String, dynamic>> _generateSchedulesForDay(int day) {
    // Different schedule templates
    List<List<Map<String, dynamic>>> scheduleTemplates = [
      // Template 1: Emotion & Focus
      [
        {
          'title': AppString.emotionRegulation,
          'subtitle': AppString.practiceGroundingTechnique,
          'duration': '5${AppString.minuteMeditation}',
          'time': '09:00${AppString.am} - 09:05 ${AppString.am}',
          'backgroundColor': 'primary50',
        },
        {
          'title': 'Focus Training',
          'subtitle': 'Deep breathing exercise',
          'duration': '10${AppString.minuteMeditation}',
          'time': '14:00${AppString.pm} - 14:10 ${AppString.pm}',
          'backgroundColor': 'green50',
        },
        {
          'title': 'Mindfulness',
          'subtitle': 'Evening reflection',
          'duration': '15${AppString.minuteMeditation}',
          'time': '20:00${AppString.pm} - 20:15 ${AppString.pm}',
          'backgroundColor': 'blue50',
        },
      ],
      // Template 2: Energy & Calm
      [
        {
          'title': 'Morning Energy',
          'subtitle': 'Start your day with vitality',
          'duration': '8${AppString.minuteMeditation}',
          'time': '07:30${AppString.am} - 07:38 ${AppString.am}',
          'backgroundColor': 'orange50',
        },
        {
          'title': 'Stress Relief',
          'subtitle': 'Progressive muscle relaxation',
          'duration': '12${AppString.minuteMeditation}',
          'time': '15:30${AppString.pm} - 15:42 ${AppString.pm}',
          'backgroundColor': 'red50',
        },
        {
          'title': 'Evening Calm',
          'subtitle': 'Prepare for restful sleep',
          'duration': '10${AppString.minuteMeditation}',
          'time': '21:30${AppString.pm} - 21:40 ${AppString.pm}',
          'backgroundColor': 'babygreen50',
        },
      ],
      // Template 3: Gratitude & Awareness
      [
        {
          'title': 'Gratitude Practice',
          'subtitle': 'Count your daily blessings',
          'duration': '6${AppString.minuteMeditation}',
          'time': '08:00${AppString.am} - 08:06 ${AppString.am}',
          'backgroundColor': 'babygreen50',
        },
        {
          'title': 'Body Awareness',
          'subtitle': 'Full body scan meditation',
          'duration': '18${AppString.minuteMeditation}',
          'time': '13:00${AppString.pm} - 13:18 ${AppString.pm}',
          'backgroundColor': 'green50',
        },
        {
          'title': 'Loving Kindness',
          'subtitle': 'Compassion meditation',
          'duration': '12${AppString.minuteMeditation}',
          'time': '19:30${AppString.pm} - 19:42 ${AppString.pm}',
          'backgroundColor': 'primary50',
        },
      ],
      // Template 4: Focus & Clarity
      [
        {
          'title': 'Mental Clarity',
          'subtitle': 'Clear mind meditation',
          'duration': '7${AppString.minuteMeditation}',
          'time': '06:45${AppString.am} - 06:52 ${AppString.am}',
          'backgroundColor': 'blue50',
        },
        {
          'title': 'Concentration',
          'subtitle': 'Enhance focus and attention',
          'duration': '14${AppString.minuteMeditation}',
          'time': '12:30${AppString.pm} - 12:44 ${AppString.pm}',
          'backgroundColor': 'orange50',
        },
        {
          'title': 'Night Reflection',
          'subtitle': 'Review and release the day',
          'duration': '9${AppString.minuteMeditation}',
          'time': '22:15${AppString.pm} - 22:24 ${AppString.pm}',
          'backgroundColor': 'red50',
        },
      ],
      // Template 5: Balance & Harmony
      [
        {
          'title': 'Inner Balance',
          'subtitle': 'Find your center',
          'duration': '11${AppString.minuteMeditation}',
          'time': '07:00${AppString.am} - 07:11 ${AppString.am}',
          'backgroundColor': 'primary50',
        },
        {
          'title': 'Harmony Practice',
          'subtitle': 'Align mind and body',
          'duration': '16${AppString.minuteMeditation}',
          'time': '16:00${AppString.pm} - 16:16 ${AppString.pm}',
          'backgroundColor': 'babygreen50',
        },
        {
          'title': 'Peaceful Rest',
          'subtitle': 'Transition to sleep',
          'duration': '8${AppString.minuteMeditation}',
          'time': '21:00${AppString.pm} - 21:08 ${AppString.pm}',
          'backgroundColor': 'green50',
        },
      ],
    ];

    // Use different template based on day to create variety
    int templateIndex = (day - 1) % scheduleTemplates.length;
    return scheduleTemplates[templateIndex];
  }

  // Get schedules for selected date
  List<Map<String, dynamic>> get selectedDateSchedules {
    String dateKey = _formatDate(selectedDate.value);
    return scheduleData[dateKey] ?? [];
  }

  // Helper method to format date as string key
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    // CarouselSliderController doesn't need manual disposal
    super.onClose();
  }
}
