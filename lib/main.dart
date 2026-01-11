/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/core/app_bindings/app_bindings.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/service/timer_service/timer_service.dart';
import 'package:better_help/utils/app_colors/app_colors.dart';
import 'package:better_help/widget/app_deviceutils/app_device_utils.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:core_kit/initializer.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:flutter/foundation.dart';
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
  //! Initialize cached tokens
  await MyApp.initializeTokens();
  //! Initialize TimerService as a service
  Get.put(TimerService(), permanent: true);
  DeviceUtils.lockDevicePortrait();
  //! Initial Bindings
  AppInitialBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Cache tokens in memory for synchronous access

  // Initialize tokens from storage
  static Future<void> initializeTokens() async {
  }

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
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.normal),
        ),
      ),
      getPages: AppRoute.appRoutes,
      builder: (context, child) {
        return CoreKit.init(
          back: () {
            Get.back();
          },
          designSize: const Size(428, 926),
          imageBaseUrl: AppApiurl.imageUrl,
          navigatorKey: Get.key,
          dioServiceConfig: DioServiceConfig(
            baseUrl: AppApiurl.baseUrl,
            refreshTokenEndpoint: AppApiurl.refreshToken,
            onLogout: () {
              StorageService().removeTokens();
              Get.offAllNamed(AppRoute.splashscreen);
            },
            enableDebugLogs: kDebugMode,
          ),
          tokenProvider: TokenProvider(
            accessToken: () =>
                StorageService().getAccessToken().then((v) => v ?? ''),
            refreshToken: () =>
                StorageService().getRefreshToken().then((v) => v ?? ''),
            updateTokens: (data) async {
              await StorageService().saveAccessToken(data['accessToken']);
            },
            clearTokens: () async {
              await StorageService().removeTokens();
            },
          ),
          child: child,
        );
      },
    );
  }
}
