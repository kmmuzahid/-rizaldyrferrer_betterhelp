import 'package:better_help/utils/app_log/app_log.dart';
import 'package:get/get.dart';

import '../../screen/community_sections/creating_post/controller/creating_post_controller.dart';
import '../../screen/community_sections/main_community/controller/community_screen_controller.dart';

class CommunityBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunityScreenController>(() {
      appLog("CommunityScreenController is initialized");
      return CommunityScreenController();
    }, fenix: true);
    Get.lazyPut<CreatingPostController>(() {
      appLog("CreatingPostController is initialized");
      return CreatingPostController();
    }, fenix: true);
  }
}
