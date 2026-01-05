import 'package:get/get.dart';

import '../../service/connectivity_service/connectivity_services.dart';
import '../../utils/app_log/app_log.dart';

class AppInitialBindings implements Bindings {
  @override
  void dependencies() {

     Get.lazyPut<ConnectivityService>(() {
      appLog('Registering ConnectivityService');
      return ConnectivityService();
    }, fenix: true);
  }
}