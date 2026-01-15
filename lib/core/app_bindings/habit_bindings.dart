import 'package:get/get.dart';
import '../../screen/habits_sections/main_habits/controller/habits_screen_controller.dart';
import '../../screen/habits_sections/my_task/controller/my_task_controller.dart';
import '../../screen/habits_sections/timer_screen/controller/timer_screen_contorller.dart';
import '../../utils/app_log/app_log.dart';

class HabitBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HabitsScreenController>(() {
      appLog("Habits Screen Controller is Initialized");
      return HabitsScreenController();
    }, fenix: true);
    Get.lazyPut<MyTaskController>(() {
      appLog("My Task Controller is Initialized");
      return MyTaskController();
    }, fenix: true);

    Get.lazyPut<TimerScreenController>(() {
      appLog("Timer Screen Controller is Initialized");
      return TimerScreenController();
    }, fenix: true);
  }
}
