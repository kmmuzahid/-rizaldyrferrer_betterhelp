import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/service/api/api_services.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/utils/app_log/app_log.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  final _apiServices = ApiServices.instance;
  final _storageServices = StorageService();

  /// Get user profile
  Future<Map<String, dynamic>?> getMyProfile() async {
    try {
      final token = await _storageServices.getAccessToken();

      final response = await _apiServices.apiGetServices(
        AppApiurl.getMyProfile,
        headers: {'Authorization': 'Bearer $token'},
      );

      return response;
    } catch (e) {
      return null;
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>?> updateMyProfile({
    String? fullName,
    String? phone,
    String? address,
    dynamic profile,
  }) async {
    try {
      final token = await _storageServices.getAccessToken();
      appLog('🔑 Token retrieved for update profile');

      // Build FormData manually to ensure clean structure
      FormData formData = FormData();

      if (fullName != null && fullName.isNotEmpty) {
        formData.fields.add(MapEntry('fullName', fullName));
        appLog('📝 Adding fullName: $fullName');
      }
      if (phone != null && phone.isNotEmpty) {
        formData.fields.add(MapEntry('phone', phone));
        appLog('📞 Adding phone: $phone');
      }
      if (address != null && address.isNotEmpty) {
        formData.fields.add(MapEntry('address', address));
        appLog('📍 Adding address: $address');
      }
      if (profile != null) {
        formData.files.add(MapEntry('profile', profile));
        appLog('🖼️ Adding profile image to form data as file');
      }

      appLog('📦 FormData fields: ${formData.fields.length}');
      appLog('📦 FormData files: ${formData.files.length}');

      appLog('🚀 Sending PATCH request to: ${AppApiurl.editMyProfile}');

      // Create options with proper headers for multipart
      final options = Options(
        headers: {'Authorization': 'Bearer $token'},
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        validateStatus: (status) {
          return status != null && status < 500;
        },
      );

      final response = await _apiServices.apiPatchServices(
        url: AppApiurl.editMyProfile,
        body: formData,
        options: options,
      );

      appLog('✅ Profile update response received: $response');
      return response;
    } catch (e) {
      appLog('❌ Error in updateMyProfile repository: $e');
      appLog('Error type: ${e.runtimeType}');
      if (e is DioException) {
        appLog('DioException type: ${e.type}');
        appLog('DioException message: ${e.message}');
        appLog('DioException response: ${e.response?.data}');
      }
      return null;
    }
  }
}
