import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/progress_sections/main_progress/controller/model/task_summery_model.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class ProgressScreenController extends GetxController {
  // Loading state
  var isLoading = true.obs;

  // Chart data
  var chartData = <FlSpot>[].obs;
  // Progress data
  var totalTask = 0.obs;
  var completed = 0.obs;
  var pendingTask = 0.obs;
  var overdeueTask = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProgressData();
  }

  Future<void> loadProgressData() async {
    isLoading.value = true;
    final result = await CkTransport.request(
      input: RequestInput(endpoint: ApiEndPoints.taskStatistics, method: RequestMethod.GET),
      responseBuilder: (data) {
        return TaskSummaryModel.fromMap(data);
      },
    );
    if (result.isSuccess) {
      totalTask.value = result.data?.totalTasks ?? 0;
      completed.value = result.data?.totalCompletedTask ?? 0;
      pendingTask.value = result.data?.totalPendingTask ?? 0;
      overdeueTask.value = result.data?.totalOverdueTask ?? 0;
      for (var i = 0; i < (result.data?.data ?? []).length; i++) {
        chartData.add(FlSpot(i.toDouble(), (result.data?.data ?? [])[i].task.toDouble()));
      }
    }
    isLoading.value = false;
  }
}
