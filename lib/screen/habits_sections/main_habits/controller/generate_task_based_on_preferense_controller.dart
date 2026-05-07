import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/habits_sections/main_habits/model/task_info_model.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
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

    final result = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.createTask,
        method: .POST,
        listBody: tasksToAdd,
      ),
      responseBuilder: (data) {
        return data;
      },
    );

    Get.snackbar(result.isSuccess ? "Success" : "Error", result.message ?? '');

    if (result.isSuccess) {
      //TO-DO:call api for task list
    }
  }

  void regenerateTasks() async {
    if (isLoading.value) return;
    aiTasks.clear();
    isLoading.value = true;
    final result = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.generateTaskByAi,
        method: .POST,
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
