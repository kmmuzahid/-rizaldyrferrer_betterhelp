import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_log/error_log.dart';
import 'package:core_kit/network/response_state.dart';
import 'package:dio/dio.dart';

class AuthReporsitory {
  final _apiServices = ApiServices.instance;
  final _storageService = StorageService();

  //! Login user
  //! Returns the response data on success, null on failure
  Future<ResponseState<dynamic>?> loginUser({
    required dynamic email,
    required dynamic password,
  }) async {
    try {
      final body = {"email": email, "password": password};

      final response = await _apiServices.apiPostServices(
        url: ApiEndPoints.login,
        body: body,
      );

      if (response.isSuccess) {
        final data = response.data;
        if (data != null) {
          await _storageService.saveAccessToken(data['accessToken']);
          await _storageService.saveRefreshToken(data['refreshToken']);
          await _storageService.saveUserData(data['user']);
        }

        return response;
      } else {
        appLog('AuthRepository: Login failed - null response or success false');
        return null;
      }
    } catch (e) {
      errorLog('AuthRepository: Exception during login', e);
      return null;
    }
  }

  //! Creates a new user account
  //! Returns the response data on success, null on failure
  Future<dynamic> createUser({
    required dynamic fullName,
    required dynamic email,
    required dynamic password,
  }) async {
    appLog('AuthRepository: Starting user creation...');
    appLog('AuthRepository: Email - $email');
    appLog('AuthRepository: FullName - $fullName');

    try {
      final body = {
        "fullName": fullName,
        "email": email,
        "password": password,
        "role": "user",
      };

      appLog('AuthRepository: Request body prepared');
      appLog('AuthRepository: Calling API - ${ApiEndPoints.createUser}');

      final response = await _apiServices.apiPostServices(
        url: ApiEndPoints.createUser,
        body: body,
      );

      appLog('AuthRepository: User created successfully');
      appLog('AuthRepository: Response - $response');
      return response;
    } catch (e) {
      errorLog('AuthRepository: Exception during user creation', e);
      return null;
    }
  }

  //! Verify OTP with questionnaire responses
  //! Returns the response data on success, null on failure
  Future<dynamic> verifyOtp({required dynamic otp}) async {
    appLog('AuthRepository: Starting OTP verification...');
    appLog('AuthRepository: OTP - $otp');

    try {
      //! Get saved createUserToken from storage
      final createUserToken = await _storageService.getCreateUserToken();
      appLog('AuthRepository: Retrieved createUserToken from storage');

      //! Get saved questionnaire responses from storage
      final responses = await _storageService.getQuestionnaireResponses();
      appLog('AuthRepository: Retrieved responses from storage - $responses');

      //! Get saved questionnaire output from storage
      final questionOutput = await _storageService.getQuestionnaireOutput();
      appLog(
        'AuthRepository: Retrieved questionOutput from storage - $questionOutput',
      );

      //! Build body matching the expected format
      final body = {
        "otp": int.tryParse(otp) ?? otp,
        if (responses != null) "questions": responses,
        if (questionOutput != null) "questionOutput": questionOutput,
      };

      appLog('AuthRepository: Request body prepared - $body');
      appLog('AuthRepository: Calling API - ${ApiEndPoints.verifyOtp}');

      //! Send token in header
      final response = await _apiServices.apiPostServices(
        url: ApiEndPoints.verifyOtp,
        body: body,
        header: {'token': ?createUserToken},
      );

      appLog('AuthRepository: OTP verified successfully');
      appLog('AuthRepository: Response - $response');

      //! Clear all stored data after successful verification
      await _storageService.removeQuestionnaireResponses();
      await _storageService.removeQuestionnaireOutput();
      await _storageService.removeCreateUserToken();
      appLog('AuthRepository: Cleared all questionnaire data from storage');

      return response;
    } catch (e) {
      errorLog('AuthRepository: Exception during OTP verification', e);
      return null;
    }
  }

  //! Resend OTP
  Future<dynamic> resendOtp({required dynamic email}) async {
    appLog('AuthRepository: Resending OTP...');
    appLog('AuthRepository: Email - $email');
    final createUserToken = await _storageService.getCreateUserToken();

    try {
      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.resendOtp,
        options: Options(headers: {'token': createUserToken}),
      );

      if (response != null) {
        appLog('AuthRepository: OTP resent successfully');
        return response;
      } else {
        appLog('AuthRepository: Resend OTP failed');
        return null;
      }
    } catch (e) {
      errorLog('AuthRepository: Exception during resend OTP', e);
      return null;
    }
  }

  //! Forgot Password - Send OTP to email
  Future<dynamic> forgotPassword({required String email}) async {
    appLog('AuthRepository: Starting forgot password...');
    appLog('AuthRepository: Email - $email');

    try {
      final body = {"email": email};

      final response = await _apiServices.apiPostServices(
        url: ApiEndPoints.forgotPassword,
        body: body,
      );

      appLog('AuthRepository: Forgot password OTP sent successfully');

      // Save forgetToken for OTP verification
      if (response.data != null && response.data['forgetToken'] != null) {
        await _storageService.saveString(
          'forget_token',
          response.data['forgetToken'],
        );
        appLog('AuthRepository: forgetToken saved');
      }

      return response;
    } catch (e) {
      errorLog('AuthRepository: Exception during forgot password', e);
      return null;
    }
  }

  //! Verify Forgot Password OTP using PATCH method
  Future<dynamic> verifyForgotPasswordOtp({required String otp}) async {
    appLog('AuthRepository: Verifying forgot password OTP...');

    try {
      final forgetToken = await _storageService.getString('forget_token');
      appLog('AuthRepository: Retrieved forgetToken from storage');

      final body = {"otp": otp};

      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.forgotPasswordOtpMatch,
        body: body,
        options: Options(headers: {'token': forgetToken}),
      );

      if (response != null) {
        appLog('AuthRepository: Forgot password OTP verified');
        return response;
      } else {
        appLog('AuthRepository: Forgot password OTP verification failed');
        return null;
      }
    } catch (e) {
      errorLog(
        'AuthRepository: Exception during forgot password OTP verification',
        e,
      );
      return null;
    }
  }

  //! Resend Forgot Password OTP
  Future<dynamic> resendForgotPasswordOtp() async {
    appLog('AuthRepository: Resending forgot password OTP...');

    try {
      final forgetToken = await _storageService.getString('forget_token');

      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.forgotPassworResendOtp,
        options: Options(headers: {'token': forgetToken}),
      );

      if (response != null) {
        appLog('AuthRepository: Forgot password OTP resent successfully');
        return response;
      } else {
        appLog('AuthRepository: Resend forgot password OTP failed');
        return null;
      }
    } catch (e) {
      errorLog(
        'AuthRepository: Exception during resend forgot password OTP',
        e,
      );
      return null;
    }
  }

  //! Reset Password (after forgot password OTP verification)
  Future<dynamic> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    appLog('AuthRepository: Resetting password...');

    try {
      final forgetToken = await _storageService.getString('forget_token');
      appLog('AuthRepository: forgetToken - $forgetToken');

      final body = {"newPassword": newPassword, "oldPassword": oldPassword};

      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.forgotPassoword,
        body: body,
        options: Options(headers: {'token': forgetToken}),
      );

      if (response != null && response['success'] == true) {
        appLog('AuthRepository: Password reset successfully');
        await _storageService.remove('forget_token');
        return response;
      } else {
        appLog('AuthRepository: Password reset failed');
        return null;
      }
    } catch (e) {
      errorLog('AuthRepository: Exception during password reset', e);
      return null;
    }
  }

  //! Reset Password (after forgot password OTP verification)
  Future<dynamic> forgetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    appLog('AuthRepository: Resetting password...');

    try {
      final forgetToken = await _storageService.getString('forget_token');
      appLog('AuthRepository: forgetToken - $forgetToken');

      final body = {
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      final response = await _apiServices.apiPatchServices(
        url: ApiEndPoints.resetPassword,
        body: body,
        options: Options(headers: {'token': forgetToken}),
      );

      if (response != null && response['success'] == true) {
        appLog('AuthRepository: Password reset successfully');
        await _storageService.remove('forget_token');
        return response;
      } else {
        appLog('AuthRepository: Password reset failed');
        return null;
      }
    } catch (e) {
      errorLog('AuthRepository: Exception during password reset', e);
      return null;
    }
  }
}
