import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreenController extends GetxController {
  // Loading state
  var isLoading = true.obs;

  // Chart data
  var chartData = <FlSpot>[].obs;

  // Progress data
  var pointsEarned = 325.obs;
  var completed = 244.obs;
  var bestStreakDay = 22.obs;
  var remaining = 22.obs;

  @override
  void onInit() {
    super.onInit();
    loadProgressData();
  }

  Future<void> loadProgressData() async {
    try {
      isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load chart data
      chartData.value = [
        const FlSpot(0, 1),
        const FlSpot(1, 2),
        const FlSpot(2, 3),
        const FlSpot(3, 4),
        const FlSpot(4, 5),
        const FlSpot(5, 6),
        const FlSpot(6, 7),
      ];

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      // Handle error
    }
  }
}
