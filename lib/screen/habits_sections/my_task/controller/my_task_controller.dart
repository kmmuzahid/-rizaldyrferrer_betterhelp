import 'package:get/get.dart';

class MyTaskController extends GetxController {
  RxMap<String, bool> checkboxStates = <String, bool>{}.obs;

  void toggleCheckbox(String key, bool? value) {
    checkboxStates[key] = value ?? false;
  }

  bool getCheckboxState(String key) {
    return checkboxStates[key] ?? false;
  }
}
