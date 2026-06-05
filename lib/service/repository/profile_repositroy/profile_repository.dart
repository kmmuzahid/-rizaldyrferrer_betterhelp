import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:better_help/service/storage_services/storage_services.dart';

class ProfileRepository {
  final _storageServices = StorageService();

  /// Get user profile
  // Future<ResponseState<ProfileData?>> getMyProfile() async {
  //   final response = await CkTransport.request(
  //     input: RequestInput(
  //       endpoint: ApiEndPoints.getMyProfile,
  //       method: RequestMethod.GET,
  //     ),
  //     responseBuilder: (data) => ProfileData.fromJson(data),
  //   );

  //   return response;
  // }

  /// Update user profile
  Future<ResponseState<dynamic>> updateMyProfile({
    String? fullName,
    String? phone,
    String? address,
    XFile? profile,
  }) async {
    return CkTransport.request(
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
