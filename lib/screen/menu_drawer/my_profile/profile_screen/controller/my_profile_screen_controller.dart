/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 19:55:25
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:get/get.dart';

class MyProfileScreenController extends GetxController {
  final _profileRepository = ProfileRepository();

  var isLoading = false.obs;
  var profileData = Rxn<Data>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _profileRepository.getMyProfile();

      if (response != null && response['success'] == true) {
        final profileResponse = Welcome.fromJson(response);
        profileData.value = profileResponse.data;  
      } else {
        AppSnackBar.showError("Failed to load profile");
      }
    } catch (e) {
      AppSnackBar.showError("Error loading profile");
    } finally {
      isLoading.value = false;
    }
  }

  String getProfileImageUrl() {
    if (profileData.value?.profile != null && profileData.value!.profile!.isNotEmpty) {
      final profileUrl = profileData.value!.profile!;
      // Check if it's already a complete URL (starts with http/https)
      if (profileUrl.startsWith('http://') || profileUrl.startsWith('https://')) {
        return profileUrl;
      }
      // Otherwise, prepend the base image URL
      return '${AppApiurl.imageUrl}/$profileUrl';
    }
    return '';
  }
}
