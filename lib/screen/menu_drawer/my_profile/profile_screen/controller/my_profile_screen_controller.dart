/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 19:55:25
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/core/app_route/app_route.dart';
import 'package:better_help/screen/menu_drawer/my_profile/model/my_profile_model.dart';
import 'package:better_help/screen/notification/notification_screen_controller.dart';
import 'package:better_help/service/repository/profile_repositroy/profile_repository.dart';
import 'package:better_help/service/storage_services/storage_services.dart';
import 'package:better_help/widget/app_snackbar/app_snackbar.dart';
import 'package:get/get.dart';

class MyProfileScreenController extends GetxController {
  final _profileRepository = ProfileRepository();

  var isLoading = false.obs;
  var profileData = Rxn<Data>();
  var isNotificationListening = false.obs;

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
        if (isNotificationListening.value == false) {
          Get.find<NotificationScreenController>()
            ..getUnreadCount()
            ..listenNotification();
          isNotificationListening.value = true;
        }
      } else {
        AppSnackBar.showError(response?['message']?.toString() ?? "Failed to load profile");
        StorageService().clearAll();
        Get.offAllNamed(AppRoute.loginScreen);
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
      return '${ApiEndPoints.imageUrl}/$profileUrl';
    }
    return '';
  }
}
