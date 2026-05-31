import 'dart:ui';
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:core_kit/initializer.dart';
import 'package:core_kit/network/ck_transport_config.dart';
import 'package:core_kit/auth/auth_config.dart';
import 'package:core_kit/auth/auth_endpoints.dart';
import 'package:core_kit/auth/auth_extractors.dart';
import 'package:core_kit/auth/auth_routes.dart';
import 'package:core_kit/auth/otp/otp_config.dart';
import 'package:core_kit/auth/ck_auth.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'core/app_route/app_route.dart';

class CorekitConfigImpl extends CoreKitConfig with CoreKitConfigDefaults {
  @override
  Size get designSize => const Size(428, 926);

  @override
  String get imageBaseUrl => ApiEndPoints.imageUrl;

  @override
  CkTransportConfig get ckTransportConfig => CkTransportConfig(
    baseUrl: ApiEndPoints.baseUrl,
    refreshTokenEndpoint: ApiEndPoints.refreshToken,
    onLogout: () {
      StorageService().removeTokens();
      StorageService().removeUserData();
      Get.offAllNamed(AppRoute.splashscreen);
    },
    enableDebugLogs: kDebugMode,
  );

  @override
  CkAuthConfig<ProfileData> get authConfig => CkAuthConfig<ProfileData>(
    endpoints: CkAuthEndpoints(
      signupUrl: ApiEndPoints.createUser,
      signinUrl: ApiEndPoints.login,
      forgetPasswordUrl: ApiEndPoints.forgotPassword,
      otpSendUrl: ApiEndPoints.resendOtp,
      otpVerifyUrl: ApiEndPoints.verifyOtp,
      profileGetUrl: ApiEndPoints.getMyProfile,
      profileUpdateUrl: ApiEndPoints.editMyProfile,
      logoutUrl: "${ApiEndPoints.baseUrl}/auth/logout",
      otpSendMethod: .PATCH, // patch for resend otp
    ),
    profileExtractor: (json) => ProfileData.fromJson(json),
    extractors: CkAuthExtractors<ProfileData>(
      accessToken: (data) => data['accessToken']?.toString(),
      refreshToken: (data) => data['refreshToken']?.toString(),
      profileData: (data) => data['user'],
      message: (data) => data['message']?.toString(),
      verificationTokens: {
        CkOtpTrigger.signup: (data) =>
            data['createUserToken']?.toString() ?? data['token']?.toString(),
        CkOtpTrigger.login: (data) => data['loginUserToken']?.toString(),
        CkOtpTrigger.forgetPassword: (data) => data['forgetToken']?.toString(),
      },
    ),
    otpConfig: const CkOtpConfig(
      autoTriggers: {CkOtpTrigger.signup},
      verificationStrategy: CkOtpVerificationStrategy.tokenBased,
      verificationTokenHeaderKey: 'token',
      sendVerificationTokenInHeader: true,
    ),
    routes: CkAuthRoutes(
      routeOnSuccess: () {
        final profile = CkAuth.profile as ProfileData?;
        if (profile?.subscriptionPackageId == null) {
          Get.offAllNamed(AppRoute.subscriptionscreen);
        } else {
          Get.offAllNamed(AppRoute.bottomNav);
        }
      },
      routeToLogin: () => Get.offAllNamed(AppRoute.splashscreen),
    ),
    onProfileLoaded: (profile) async {
      await StorageService().saveUserData(profile.toJson());
    },
  );
}
