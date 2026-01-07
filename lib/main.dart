import 'package:better_help/core/app_bindings/app_bindings.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/service/timer_service/timer_service.dart';
import 'package:better_help/widget/app_deviceutils/app_device_utils.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'widget/app_observer/app_observer.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  //!Initialize Storage
  await StorageService().init();
  //! Initialize GetStorage
  await GetStorage.init();
  //! Initialize TimerService as a service
  Get.put(TimerService(), permanent: true);
  DeviceUtils.lockDevicePortrait();
  //! Initial Bindings
  AppInitialBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [NavigationObserver()],
      scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      initialRoute: AppRoute.splashscreen,
      navigatorKey: Get.key,
      getPages: AppRoute.appRoutes,
    );
  }
}
