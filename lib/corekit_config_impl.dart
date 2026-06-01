import 'dart:ui';

import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_bindings/app_bindings.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/service/timer_service/timer_service.dart';
import 'package:core_kit/core_kit_internal.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'core/app_route/app_route.dart';

class CorekitConfigImpl extends CoreKitConfig with CoreKitConfigDefaults {
  @override
  Size get designSize => const Size(428, 926);

  @override
  String get imageBaseUrl => ApiEndPoints.imageUrl;

  /// Disable enforced splash delay for faster navigation
  @override
  int get splashDelayMs => 0;

  /// Custom initialization tasks run during the 3-second splash delay.
  /// Use this to register dependencies, initialize services, etc.
  @override
  Future<void> Function()? get onInit => () async {
    // Initialize TimerService as a service
    Get.put(TimerService(), permanent: true);
    // Initial Bindings
    AppInitialBindings().dependencies();
  };

  @override
  CkTransportConfig get ckTransportConfig => CkTransportConfig(
    baseUrl: ApiEndPoints.baseUrl,
    refreshTokenEndpoint: ApiEndPoints.refreshToken,
    enableDebugLogs: kDebugMode,
  );

  @override
  CkAuthConfig<ProfileData>? get authConfig => CkAuthConfig<ProfileData>(
    endpoints: CkAuthEndpoints(
      resetPassword: ApiEndPoints.resetPassword,
      forgotPassword: ApiEndPoints.forgotPassword,
      signup: ApiEndPoints.createUser,
      signin: ApiEndPoints.login,
      sendOtp: ApiEndPoints.resendOtp,
      verifyOtp: ApiEndPoints.verifyOtp,
      getProfile: ApiEndPoints.getMyProfile,
      updateProfile: ApiEndPoints.editMyProfile,
      verifyForgetOtp: ApiEndPoints.forgotPasswordOtpMatch,
      logout: "",
      resetPasswordMethod: .PATCH,
      verifyOtpMethod: .PATCH,
      sendOtpMethod: .PATCH,
    ),
    loginBodyBuilder: (LoginCallback loginCallBack) {
      return {
        'email': loginCallBack.username,
        'password': loginCallBack.password,
      };
    },
    profileExtractor: (json) => ProfileData.fromJson(json),
    extractors: CkAuthExtractors<ProfileData>(
      accessToken: (data) => data['accessToken']?.toString(),
      refreshToken: (data) => data['refreshToken']?.toString(),
      resetPasswordToken: (data) => data['forgetOtpMatchToken']?.toString(),
      profile: (data) {
        final profile = ProfileData.fromJson(data);
        return profile;
      },

      message: (data) => data['message']?.toString(),
      verificationTokens: {
        CkOtpTrigger.signup: (data) =>
            data['createUserToken']?.toString() ?? data['token']?.toString(),
        CkOtpTrigger.login: (data) => data['loginUserToken']?.toString(),
        CkOtpTrigger.forgetPassword: (data) => data['forgetToken']?.toString(),
      },
    ),
    otpConfig: CkOtpConfig(
      autoTriggers: {CkOtpTrigger.signup, .forgetPassword},
      verificationStrategy: CkOtpVerificationStrategy.tokenBased,
      verificationTokenHeaderKey: 'token',
      sendVerificationTokenInHeader: true,
      verifyBodyBuilder: (ctx) {
        return {"otp": ctx.otp};
      },
      resendBodyBuilder: (ctx) {
        return {"email": ctx.identifier};
      },
    ),
    handlers: CkAuthFlowHandlers(
      showResetPassword: () {
        Get.offNamed(
          AppRoute.changePasswrodScreen,
          arguments: {'isForgetPassword': true},
        );
      },
      showOtpVerification: () {
        Get.toNamed(
          AppRoute.otpVerificationScreen,
          arguments: {'screen': "", 'email': ""},
        );
      },
      onAuthenticated: () {
        final profile = CkAuth.profile as ProfileData?;
        if (profile?.subscriptionPackageId == null) {
          Get.offAllNamed(AppRoute.subscriptionscreen);
        } else {
          Get.offAllNamed(AppRoute.bottomNav);
        }
      },
      showLogin: () {
        Get.offAllNamed(AppRoute.loginScreen);
      },
      showOnboarding: () {
        Get.offAllNamed(AppRoute.onboardingscreen);
      },
    ),
  );
}
