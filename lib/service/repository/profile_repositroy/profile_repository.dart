import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';

class ProfileRepository {
  final _storageServices = StorageService();

  /// Get user profile
  Future<ResponseState<dynamic>?> getMyProfile() async {
    final response = await DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.getMyProfile,
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => data,
    );

    return response;
  }

  /// Update user profile
  Future<ResponseState<dynamic>> updateMyProfile({
    String? fullName,
    String? phone,
    String? address,
    XFile? profile,
  }) async {
    return DioService.instance.request(
      input: RequestInput(
        endpoint: ApiEndPoints.editMyProfile,
        formFields: {'fullName': fullName, 'phone': phone, 'address': address},
        files: {'profile': profile},
        method: RequestMethod.PATCH,
      ),
      responseBuilder: (data) => data,
    );
  }
}
