import 'dart:ui';

import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:core_kit/initializer.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/dio_service_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'core/app_route/app_route.dart';

class CorekitConfigImpl extends CoreKitConfig with CoreKitConfigDefaults {
  @override
  Size get designSize => const Size(428, 926);

  @override
  DioServiceConfig get dioConfig => DioServiceConfig(
    baseUrl: ApiEndPoints.baseUrl,
    refreshTokenEndpoint: ApiEndPoints.refreshToken,
    onLogout: () {
      StorageService().removeTokens();
      Get.offAllNamed(AppRoute.splashscreen);
    },
    enableDebugLogs: kDebugMode,
  );

  @override
  String get imageBaseUrl => ApiEndPoints.imageUrl;

  @override
  TokenProvider get tokenProvider => TokenProvider(
    accessToken: () => StorageService().getAccessToken().then((v) => v ?? ''),
    refreshToken: () => StorageService().getRefreshToken().then((v) => v ?? ''),
    updateTokens: (data) =>
        StorageService().saveAccessToken(data['accessToken']),
  );
}
