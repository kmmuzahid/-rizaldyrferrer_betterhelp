import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/habits_sections/main_habits/model/daily_task_model.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:better_help/widget/generate_task/generate_task_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class HabitsScreenController extends GetxController {
  final _apiServices = ApiServices.instance;

  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentIndex = 0.obs;
  var selectedDate = DateTime.now().obs;
  var checklistStates = <bool>[false, false, false].obs;

  // Track expanded task index
  var expandedTaskIndex = (-1).obs;

  // API related observables
  final RxBool isLoadingTasks = false.obs;
  final RxList<Rx<TaskModel>> tasks = <Rx<TaskModel>>[].obs;

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

  RxList dailyAffermationList = [
    AppStaticImages.dailyAffermation01,
    AppStaticImages.dailyAffermation02,
    AppStaticImages.dailyAffermation03,
    AppStaticImages.dailyAffermation04,
    AppStaticImages.dailyAffermation05,
    AppStaticImages.dailyAffermation06,
    AppStaticImages.dailyAffermation07,
    AppStaticImages.dailyAffermation08,
  ].obs;

  void startNow(String id) async {
    final result = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.taskStatus(id, "do_now"),
        method: .PATCH,
      ),
      responseBuilder: (data) => data,
    );
    if (result.isSuccess) {
      final index = tasks.indexWhere((element) => element.value.id == id);

      if (index != -1) {
        tasks[index].value = tasks[index].value.copyWith(status: "do_now");
        tasks.refresh();
      }
    }
  }

  void postpone(String id) async {
    final result = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.taskStatus(id, "postpone"),
        method: .PATCH,
      ),
      responseBuilder: (data) => data,
    );
    if (result.isSuccess) {
      final index = tasks.indexWhere((element) => element.value.id == id);

      if (index != -1) {
        tasks[index].value = tasks[index].value.copyWith(status: "postpone");
        tasks.refresh();
      }
    }
  }

  void skip(String id) async {
    final result = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: ApiEndPoints.taskStatus(id, "skip"),
        method: .PATCH,
      ),
      responseBuilder: (data) => data,
    );
    if (result.isSuccess) {
      final index = tasks.indexWhere((element) => element.value.id == id);

      if (index != -1) {
        tasks[index].value = tasks[index].value.copyWith(status: "skip");
        tasks.refresh();
      }
    }
  }

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
    expandedTaskIndex.value = -1; // Reset expansion when date changes
    fetchTasksByDate(date);
  }

  // Method to toggle task expansion
  void toggleTaskExpansion(int index) {
    if (expandedTaskIndex.value == index) {
      expandedTaskIndex.value = -1;
    } else {
      expandedTaskIndex.value = index;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch tasks for today on initialization
    fetchTasksByDate(selectedDate.value);
    checkFirstTimeUser();
  }

  void checkFirstTimeUser() async {
    final isFirstTimeUser = await StorageService.instance
        .isFirstAiTaskGenereted();

    if (isFirstTimeUser == null || !isFirstTimeUser) {
      Get.dialog(const GenerateTaskDialog());
    }
  }

  /// Fetch tasks by date from API
  Future<void> fetchTasksByDate(DateTime date) async {
    try {
      isLoadingTasks.value = true;

      // Format date to ISO 8601 format: "2026-01-12T00:00:00.000Z"
      final formattedDate = DateTime(
        date.year,
        date.month,
        date.day,
        12,
      ).toUtc().toIso8601String();

      appLog('Fetching tasks for date: $formattedDate');

      final response = await _apiServices.apiGetServices(
        ApiEndPoints.taskBytheDate(formattedDate),
      );

      if (response != null && response['success'] == true) {
        appLog('Tasks fetched successfully');

        final taskResponse = TaskResponse.fromJson(response);

        if (taskResponse.data != null) {
          tasks.value = taskResponse.data!.map((task) => task.obs).toList();
          appLog('Loaded ${tasks.length} tasks for ${_formatDate(date)}');
        } else {
          tasks.clear();
          appLog('No tasks found for ${_formatDate(date)}');
        }
      } else {
        appLog('Failed to fetch tasks');
        tasks.clear();
      }
    } catch (e) {
      appLog('Error fetching tasks: $e');
      tasks.clear();
    } finally {
      isLoadingTasks.value = false;
    }
  }

  /// Refresh tasks for current selected date
  Future<void> refreshTasks() async {
    await fetchTasksByDate(selectedDate.value);
  }

  /// Mark task as completed
  Future<void> markTaskAsCompleted(String taskId) async {
    try {
      appLog('Marking task $taskId as completed');
      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.taskCompleted(taskId),
      );

      if (response != null && response['success'] == true) {
        appLog('Task $taskId marked as completed successfully');
        // Refresh tasks to reflect status change
        await refreshTasks();
        showSnackBar("Task marked as completed", type: SnackBarType.success);
      } else {
        appLog('Failed to mark task $taskId as completed');
        showSnackBar(
          "Failed to mark task as completed",
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      appLog('Error marking task as completed: $e');
      showSnackBar("An error occurred", type: SnackBarType.error);
    }
  }

  /// Mark task as cancelled
  Future<void> markTaskAsCancelled(String taskId) async {
    try {
      appLog('Marking task $taskId as cancelled');
      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.taskCancelled(taskId),
      );

      if (response != null && response['success'] == true) {
        appLog('Task $taskId marked as cancelled successfully');
        // Refresh tasks to reflect status change
        await refreshTasks();
        showSnackBar("Task cancelled successfully", type: SnackBarType.success);
      } else {
        appLog('Failed to mark task $taskId as cancelled');
        showSnackBar("Failed to cancel task", type: SnackBarType.error);
      }
    } catch (e) {
      appLog('Error marking task as cancelled: $e');
      showSnackBar("An error occurred", type: SnackBarType.error);
    }
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

  // Helper method to format date as string key
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Calculate duration between start and end date
  String calculateDuration(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return '0${AppString.minuteMeditation}';
    }

    final duration = endDate.difference(startDate);
    final minutes = duration.inMinutes;

    return '$minutes-minute';
  }

  /// Format time range for display
  String formatTimeRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return 'Time not set';
    }

    final startHour = startDate.hour;
    final startMinute = startDate.minute.toString().padLeft(2, '0');
    final startPeriod = startHour >= 12 ? AppString.pm : AppString.am;
    final displayStartHour = startHour > 12
        ? startHour - 12
        : (startHour == 0 ? 12 : startHour);

    if (endDate == null) {
      return '${displayStartHour.toString().padLeft(2, '0')}:$startMinute $startPeriod';
    }

    final endHour = endDate.hour;
    final endMinute = endDate.minute.toString().padLeft(2, '0');
    final endPeriod = endHour >= 12 ? AppString.pm : AppString.am;
    final displayEndHour = endHour > 12
        ? endHour - 12
        : (endHour == 0 ? 12 : endHour);

    return '${displayStartHour.toString().padLeft(2, '0')}:$startMinute $startPeriod - ${displayEndHour.toString().padLeft(2, '0')}:$endMinute $endPeriod';
  }

  @override
  void onClose() {
    // CarouselSliderController doesn't need manual disposal
    super.onClose();
  }
}
