/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_bindings/app_bindings.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/corekit_config_impl.dart';
import 'package:better_help/screen/notification/notification_service.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_deviceutils/app_device_utils.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/initializer.dart';
import 'package:core_kit/utils/ck_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'widget/app_observer/app_observer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.instance.initialize(notificationTapBackground);

  //!Initialize Storage
  await StorageService().init();
  DeviceUtils.lockDevicePortrait();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreKit.builder(
      config: CorekitConfigImpl(),
      navigatorKey: navigatorKey,
      app: (corkitInitBuilder) {
        return _materialApp(corkitInitBuilder);
      },
    );
  }

  Widget _materialApp(CorkitInitBuilder builder) {
    return GetMaterialApp(
      navigatorObservers: [NavigationObserver()],
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
      initialBinding: AppInitialBindings(),
      initialRoute: AppRoute.splashscreen,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.black, width: 0),
            textStyle: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),

            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            elevation: 0,
          ),
        ),
        scaffoldBackgroundColor: AppColors.white,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.normal),

          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary300),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary300),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary400,
          primary: AppColors.primary400, // button, Snackbar Info
          onPrimary: Colors.white, // text on button
          surface: AppColors.white, //card color, SnackBar Background
          tertiary: const Color(0xFFF59E0B), // SnackBar Warning
          error: const Color(0xFFEF4444), // SnackBar Erro
        ),
      ),

      getPages: AppRoute.appRoutes,
      builder: builder,
    );
  }
}
