import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/app_log/app_log.dart';
import '../../utils/app_log/error_log.dart';

class AppApi {
  final Dio _dio = Dio();

  AppApi._privateConstructor();

  static final AppApi _instance = AppApi._privateConstructor();

  static AppApi get instance => _instance;
  var storageServices = StorageService();

  AppApi() {
    _dio.options.baseUrl = AppApiurl.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 30);
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.followRedirects = false;

    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiurl.baseUrl;

          // Only set content-type to JSON if it's not a FormData request
          // FormData requests need multipart/form-data content-type
          if (options.data is! FormData) {
            options.contentType = 'application/json';
          }

          options.headers["Accept"] = "application/json";

          // Always get fresh token from storage for each request
          String token = await storageServices.getAccessToken() ?? '';

          if (kDebugMode) {
            appLog("API Request to: ${options.path}");
            appLog("Token present: ${token.isNotEmpty}");
            if (token.isNotEmpty) {
              appLog(
                "Token (first 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...",
              );
            }
          }

          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          } else if (options.headers["Authorization"] == null) {
            appLog(
              "WARNING: No token found for API request to ${options.path}",
            );
          }

          return handler.next(options); // Continue request
        },
        onError: (error, handler) async {
          appLog("API error occurred:");
          appLog("Status code: ${error.response?.statusCode}");
          appLog("Error message: ${error.message}");

          try {
            if (error.response?.statusCode == 401) {
              await storageServices.clearAll();
              // Get.offAllNamed(AppRoutes.instance.loginScreen);
              return handler.next(error);
            }
          } catch (e) {
            errorLog("error form api try and catch bloc", e);
            return handler.next(error);
          }

          return handler.next(error); // Continue with error
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
    });
  }

  Dio get sendRequest => _dio;
}
