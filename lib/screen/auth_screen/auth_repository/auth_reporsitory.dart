import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/utils/app_log/error_log.dart';
import 'package:dio/dio.dart';

class AuthReporsitory {
  final _apiServices = ApiServices.instance;
  final _storageService = StorageService();

  /// Creates a new user account
  /// Returns the response data on success, null on failure
  Future<dynamic> createUser({
    required String fullName,
    required String email,
    required String password,
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
      appLog('AuthRepository: Calling API - ${AppApiurl.createUser}');

      final response = await _apiServices.apiPostServices(
        url: AppApiurl.createUser,
        body: body,
      );

      if (response != null) {
        appLog('AuthRepository: User created successfully');
        appLog('AuthRepository: Response - $response');
        return response;
      } else {
        appLog('AuthRepository: User creation failed - null response');
        return null;
      }
    } catch (e) {
      errorLog('AuthRepository: Exception during user creation', e);
      return null;
    }
  }

  /// Verify OTP with questionnaire responses
  /// Returns the response data on success, null on failure
  Future<dynamic> verifyOtp({required dynamic otp}) async {
    appLog('AuthRepository: Starting OTP verification...');
    appLog('AuthRepository: OTP - $otp');

    try {
      // Get saved createUserToken from storage
      final createUserToken = await _storageService.getCreateUserToken();
      appLog('AuthRepository: Retrieved createUserToken from storage');

      // Get saved questionnaire responses from storage
      final responses = await _storageService.getQuestionnaireResponses();
      appLog('AuthRepository: Retrieved responses from storage - $responses');

      // Get saved questionnaire output from storage
      final questionOutput = await _storageService.getQuestionnaireOutput();
      appLog(
        'AuthRepository: Retrieved questionOutput from storage - $questionOutput',
      );

      // Build body matching the expected format
      final body = {
        "otp": int.tryParse(otp) ?? otp,
        if (responses != null) "questions": responses,
        if (questionOutput != null) "questionOutput": questionOutput,
      };

      appLog('AuthRepository: Request body prepared - $body');
      appLog('AuthRepository: Calling API - ${AppApiurl.verifyOtp}');

      // Send token in header
      final response = await _apiServices.apiPostServices(
        url: AppApiurl.verifyOtp,
        body: body,
        header: {'token': createUserToken},
      );

      if (response != null) {
        appLog('AuthRepository: OTP verified successfully');
        appLog('AuthRepository: Response - $response');

        // Clear all stored data after successful verification
        await _storageService.removeQuestionnaireResponses();
        await _storageService.removeQuestionnaireOutput();
        await _storageService.removeCreateUserToken();
        appLog('AuthRepository: Cleared all questionnaire data from storage');

        return response;
      } else {
        appLog('AuthRepository: OTP verification failed - null response');
        return null;
      }
    } catch (e) {
      errorLog('AuthRepository: Exception during OTP verification', e);
      return null;
    }
  }

  /// Resend OTP
  Future<dynamic> resendOtp({required dynamic email}) async {
    appLog('AuthRepository: Resending OTP...');
    appLog('AuthRepository: Email - $email');
    final createUserToken = await _storageService.getCreateUserToken();

    try {
      final response = await _apiServices.apiPatchServices(
        url: AppApiurl.resendOtp,
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
}
