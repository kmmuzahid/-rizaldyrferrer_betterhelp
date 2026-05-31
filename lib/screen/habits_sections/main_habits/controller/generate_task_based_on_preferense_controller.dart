import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/habits_sections/main_habits/model/task_info_model.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/widget/generate_task/task_created_dialog.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:get/get.dart';

class GenerateTaskBasedOnPreferenceController extends GetxController {
  RxList<ExecutiveInhibitionModel> aiTasks = RxList<ExecutiveInhibitionModel>();
  RxBool isLoading = false.obs;
  late List<Map<String, String>> task;

  @override
  void onInit() {
    super.onInit();
    task = Get.arguments;
    regenerateTasks();
  }

  Future<void> addTask() async {
    //tasks to maplist
    List<Map<String, dynamic>> tasksToAdd = [];
    for (var taskData in aiTasks) {
      tasksToAdd.add({
        "name": taskData.name,
        "goal": taskData.goal,
        "task": taskData.task,
        "type": taskData.type,
        "days": taskData.days,

        "startDate": taskData.startDate.toIso8601String(),
        "endDate": taskData.endDate.toIso8601String(),
      });
    }

    final result = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.createTask,
        method: RequestMethod.POST,
        listBody: tasksToAdd,
      ),
      responseBuilder: (data) {
        return data;
      },
    );

    if (result.isSuccess) {
      StorageService.instance.setAiTaskGenerated(true);
      Get.dialog(barrierDismissible: false, const TaskCreatedDialog());
    } else {
      Get.snackbar("Error", result.message ?? '');
    }
  }

  void regenerateTasks() async {
    if (isLoading.value) return;
    aiTasks.clear();
    isLoading.value = true;
    final result = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.generateTaskByAi,
        method: RequestMethod.POST,
        listBody: task,
      ),
      responseBuilder: (data) {
        return List<ExecutiveInhibitionModel>.from(
          data.map((x) => ExecutiveInhibitionModel.fromJson(x)),
        );
      },
    );

    if (result.isSuccess && result.data != null) {
      aiTasks.assignAll(result.data!);
    }
    isLoading.value = false;
  }

  onWeeklyChange(bool value, int index) {
    aiTasks[index] = aiTasks[index].copyWith(isWeekly: value);
    update();
  }

  onDateChange(DateTime value, int index, bool isStart) {
    if (isStart) {
      aiTasks[index] = aiTasks[index].copyWith(startDate: value);
    } else {
      aiTasks[index] = aiTasks[index].copyWith(endDate: value);
    }
    update();
  }

  onDayChange(String value, int index) {
    aiTasks[index] = aiTasks[index].copyWith(
      days: aiTasks[index].days.contains(value)
          ? aiTasks[index].days.where((e) => e != value).toList()
          : [...aiTasks[index].days, value],
    );
    update();
  }
}
