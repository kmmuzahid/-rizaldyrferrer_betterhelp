import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';

class AuthReporsitory {
  final _storageService = StorageService();

  //! Login user
  //! Returns the response data on success, null on failure
  Future<ResponseState<dynamic>?> loginUser({
    required dynamic email,
    required dynamic password,
  }) async {
    final body = {"email": email, "password": password};

    final response = await CkTransport.request<Map<String, dynamic>>(
      input: RequestInput(
        endpoint: ApiEndPoints.login,
        method: RequestMethod.POST,
        jsonBody: body,
      ),
      responseBuilder: (data) => data ?? {},
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
  }

  //! Creates a new user account
  //! Returns the response data on success, null on failure
  Future<ResponseState<Map<String, dynamic>?>?> createUser({
    required dynamic fullName,
    required dynamic email,
    required dynamic password,
  }) async {
    appLog('AuthRepository: Starting user creation...');
    appLog('AuthRepository: Email - $email');
    appLog('AuthRepository: FullName - $fullName');

    final body = {
      "fullName": fullName,
      "email": email,
      "password": password,
      "role": "user",
    };

    appLog('AuthRepository: Request body prepared');
    appLog('AuthRepository: Calling API - ${ApiEndPoints.createUser}');

    final response = await CkTransport.request<Map<String, dynamic>>(
      input: RequestInput(
        endpoint: ApiEndPoints.createUser,
        method: RequestMethod.POST,
        jsonBody: body,
      ),
      responseBuilder: (data) => data ?? {},
    );

    appLog('AuthRepository: User created successfully');
    appLog('AuthRepository: Response - $response');
    return response;
  }

  //! Verify OTP with questionnaire responses
  //! Returns the response data on success, null on failure
  Future<ResponseState<dynamic>?> verifyOtp({required dynamic otp}) async {
    appLog('AuthRepository: Starting OTP verification...');
    appLog('AuthRepository: OTP - $otp');

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
    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.verifyOtp,
        method: RequestMethod.POST,
        jsonBody: body,
        headers: {'token': createUserToken ?? ''},
      ),
      responseBuilder: (data) => data,
    );

    appLog('AuthRepository: OTP verified successfully');
    appLog('AuthRepository: Response - $response');

    //! Clear all stored data after successful verification
    await _storageService.removeQuestionnaireResponses();
    await _storageService.removeQuestionnaireOutput();
    await _storageService.removeCreateUserToken();
    appLog('AuthRepository: Cleared all questionnaire data from storage');

    return response;
  }

  //! Resend OTP
  Future<ResponseState<dynamic>?> resendOtp({required dynamic email}) async {
    appLog('AuthRepository: Resending OTP...');
    appLog('AuthRepository: Email - $email');
    final createUserToken = await _storageService.getCreateUserToken();

    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.resendOtp,
        method: RequestMethod.PATCH,
        headers: {'token': createUserToken ?? ''},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('AuthRepository: OTP resent successfully');
    } else {
      appLog('AuthRepository: Resend OTP failed');
    }
    return response;
  }

  //! Forgot Password - Send OTP to email
  Future<ResponseState<dynamic>?> forgotPassword({required String email}) async {
    appLog('AuthRepository: Starting forgot password...');
    appLog('AuthRepository: Email - $email');

    final body = {"email": email};

    final response = await CkTransport.request<Map<String, dynamic>>(
      input: RequestInput(
        endpoint: ApiEndPoints.forgotPassword,
        method: RequestMethod.POST,
        jsonBody: body,
      ),
      responseBuilder: (data) => data ?? {},
    );

    appLog('AuthRepository: Forgot password OTP sent successfully');

    // Save forgetToken for OTP verification
    if (response.data != null && response.data!['forgetToken'] != null) {
      await _storageService.saveString(
        'forget_token',
        response.data!['forgetToken'],
      );
      appLog('AuthRepository: forgetToken saved');
    }

    return response;
  }

  //! Verify Forgot Password OTP using PATCH method
  Future<ResponseState<dynamic>?> verifyForgotPasswordOtp({required String otp}) async {
    appLog('AuthRepository: Verifying forgot password OTP...');

    final forgetToken = await _storageService.getString('forget_token');
    appLog('AuthRepository: Retrieved forgetToken from storage');

    final body = {"otp": otp};

    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.forgotPasswordOtpMatch,
        method: RequestMethod.PATCH,
        jsonBody: body,
        headers: {'token': forgetToken ?? ''},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('AuthRepository: Forgot password OTP verified');
    } else {
      appLog('AuthRepository: Forgot password OTP verification failed');
    }
    return response;
  }

  //! Resend Forgot Password OTP
  Future<ResponseState<dynamic>?> resendForgotPasswordOtp() async {
    appLog('AuthRepository: Resending forgot password OTP...');

    final forgetToken = await _storageService.getString('forget_token');

    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.forgotPassworResendOtp,
        method: RequestMethod.PATCH,
        headers: {'token': forgetToken ?? ''},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('AuthRepository: Forgot password OTP resent successfully');
    } else {
      appLog('AuthRepository: Resend forgot password OTP failed');
    }
    return response;
  }

  //! Reset Password (after forgot password OTP verification)
  Future<ResponseState<dynamic>?> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    appLog('AuthRepository: Resetting password...');

    final forgetToken = await _storageService.getString('forget_token');
    appLog('AuthRepository: forgetToken - $forgetToken');

    final body = {"newPassword": newPassword, "oldPassword": oldPassword};

    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.forgotPassoword,
        method: RequestMethod.PATCH,
        jsonBody: body,
        headers: {'token': forgetToken ?? ''},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('AuthRepository: Password reset successfully');
      await _storageService.remove('forget_token');
    } else {
      appLog('AuthRepository: Password reset failed');
    }
    return response;
  }

  //! Reset Password (after forgot password OTP verification)
  Future<ResponseState<dynamic>?> forgetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    appLog('AuthRepository: Resetting password...');

    final forgetToken = await _storageService.getString('forget_token');
    appLog('AuthRepository: forgetToken - $forgetToken');

    final body = {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    final response = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.resetPassword,
        method: RequestMethod.PATCH,
        jsonBody: body,
        headers: {'token': forgetToken ?? ''},
      ),
      responseBuilder: (data) => data,
    );

    if (response.isSuccess) {
      appLog('AuthRepository: Password reset successfully');
      await _storageService.remove('forget_token');
    } else {
      appLog('AuthRepository: Password reset failed');
    }
    return response;
  }
}
