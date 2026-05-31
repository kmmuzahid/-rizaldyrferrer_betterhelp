// import 'package:better_help/screen/no_internet_screen/no_internet_screen.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../service/connectivity_service/connectivity_services.dart';
// import '../app_route/app_route.dart';

// class AppInternerCheck extends GetMiddleware {
//   // final ConnectivityService connectivityService =
//   //     Get.find<ConnectivityService>();

//   @override
//   RouteSettings? redirect(String? route) {
//     if (connectivityService.connectionStatus.contains(
//       ConnectivityResult.none,
//     )) {
//       // Store the current route for navigation back when internet is restored
//       connectivityService.setPreviousRoute(route ?? AppRoute.splashscreen);
//       return RouteSettings(
//         name: AppRoute.noInternetScreen,
//         arguments: {'previousRoute': route},
//       );
//     }
//     return super.redirect(route);
//   }

//   @override
//   GetPage? onPageCalled(GetPage? page) {
//     if (connectivityService.connectionStatus.contains(
//       ConnectivityResult.none,
//     )) {
//       // Store the current route for navigation back when internet is restored
//       connectivityService.setPreviousRoute(page?.name ?? AppRoute.splashscreen);
//       return GetPage(
//         name: AppRoute.noInternetScreen,
//         page: () => const NoInternetScreen(),
//         arguments: {'previousRoute': page?.name},
//       );
//     }
//     return super.onPageCalled(page);
//   }

//   @override
//   GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
//     if (connectivityService.connectionStatus.contains(
//       ConnectivityResult.none,
//     )) {
//       return () => const NoInternetScreen();
//     }
//     return super.onPageBuildStart(page);
//   }
// }
