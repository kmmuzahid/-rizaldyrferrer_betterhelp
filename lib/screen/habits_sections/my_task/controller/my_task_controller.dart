import 'package:better_help/core/app_route/app_route.dart';
import 'package:get/get.dart';

class MyTaskController extends GetxController {
  RxMap<String, bool> checkboxStates = <String, bool>{}.obs;

  void toggleCheckbox(String key, bool? value) {
    checkboxStates[key] = value ?? false;
  }

  bool getCheckboxState(String key) {
    return checkboxStates[key] ?? false;
  }

  void markAsCompleted() {
    // Check if all tasks are completed
    List<String> requiredTasks = [
      "editPdf",
      "gratitudeJournal",
      "followGoals",
      "stretchDaily",
    ];

    bool allCompleted = requiredTasks.every((task) => getCheckboxState(task));

    if (allCompleted) {
      // All tasks completed - show success message and navigate
      // Get.snackbar(
      //   "Congratulations!",
      //   "All tasks completed successfully!",
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Get.theme.colorScheme.primary,
      //   colorText: Get.theme.colorScheme.onPrimary,
      //   duration: Duration(seconds: 2),
      // );
      Get.toNamed(AppRoute.congratulationScreen);

      // Navigate back or to completion screen
      //Get.back();
    } else {
      // Not all tasks completed - show warning
      Get.snackbar(
        "Incomplete Tasks",
        "Please complete all tasks before marking as completed.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Helper method to get completion percentage
  double get completionPercentage {
    List<String> requiredTasks = [
      "editPdf",
      "gratitudeJournal",
      "followGoals",
      "stretchDaily",
    ];

    int completedCount = requiredTasks
        .where((task) => getCheckboxState(task))
        .length;
    return completedCount / requiredTasks.length;
  }

  // Helper method to check if all tasks are completed
  bool get isAllCompleted {
    List<String> requiredTasks = [
      "editPdf",
      "gratitudeJournal",
      "followGoals",
      "stretchDaily",
    ];

    return requiredTasks.every((task) => getCheckboxState(task));
  }
}
