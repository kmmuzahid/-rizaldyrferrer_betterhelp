/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 17:05:17
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/course_details/model/course_details_model.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_help/core/compatibility/corekit_compat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailsController extends GetxController {
  // Observable state variables
  late String id;
  bool isDisposed = false;
  Rxn<CourseDetailsModel> courseDetails = Rxn<CourseDetailsModel>();
  final TextEditingController reviewController = TextEditingController();

  var selectedRating = 0.obs; // Tracks selected stars in the bottom sheet

  RxBool isPlay = false.obs;
  RxString videoDuration = "".obs;

  Rxn<BetterPlayerController> betterPlayerController =
      Rxn<BetterPlayerController>();

  void initializePlayer() {
    final videoUrl = courseDetails.value?.data.video;
    if (videoUrl == null || videoUrl.isEmpty) return;
    betterPlayerController = Rxn<BetterPlayerController>();

    isPlay.value = false;

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
    );

    betterPlayerController.value = BetterPlayerController(
      const BetterPlayerConfiguration(),
      betterPlayerDataSource: dataSource,
    );

    betterPlayerController.value!.videoPlayerController?.addListener(() {
      final controller = betterPlayerController.value?.videoPlayerController;
      if (controller == null) return;

      final duration = controller.value.duration;
      if (duration != null && duration.inSeconds > 0) {
        videoDuration.value = CkUtils.formatDurationToHms(duration);
      }
      Future.delayed(const Duration(seconds: 1)).then((value) {
        final d =
            betterPlayerController.value?.videoPlayerController?.value.duration;
        videoDuration.value = d != null
            ? CkUtils.formatDurationToHms(d)
            : '00:00:00';
      });
    });
  }

  playNow() {
    isPlay.value = true;
    betterPlayerController.value?.play();
    Future.delayed(const Duration(seconds: 5)).then((value) {
      if (!isDisposed) {
        setCourseViewCount();
      }
    });
  }

  setCourseViewCount() async {
    CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.setCourseViewCount(id),
        method: RequestMethod.PATCH,
      ),
      responseBuilder: (response) {
        return response;
      },
    );
  }

  void updateRating(int rating) async {
    selectedRating.value = rating;
  }

  void submitFeedback() async {
    final result = await CkTransport.request(
      input: RequestInput(
        endpoint: ApiEndPoints.review,
        method: RequestMethod.POST,
        jsonBody: {
          "courseId": id,
          "rating": selectedRating.value,
          "review": reviewController.text.trim(),
        },
      ),
      responseBuilder: (response) {
        return response;
      },
    );
    if (result.isSuccess) {
      CkSnackBar(result.message ?? '', type: .success);
    } else {
      CkSnackBar(result.message ?? '', type: .error);
    }
  }

  fetchCourseDetails() async {
    betterPlayerController.value?.dispose();
    final result = await CkTransport.request(
      input: RequestInput(
        endpoint: '${ApiEndPoints.getCourseList}/$id',
        method: RequestMethod.GET,
      ),
      responseBuilder: (response) {
        return CourseDetailsModel.fromJson(response);
      },
    );

    if (result.data != null) {
      courseDetails.value = result.data;
      initializePlayer();
    }
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    // Handle both 'id' and 'courseId' argument keys with null safety
    id = Get.arguments?['courseId'] ?? Get.arguments?['id'] ?? '';
    if (id.isEmpty) {
      CkSnackBar('Course ID not found', type: .error);
      Get.back();
      return;
    }
    fetchCourseDetails();
    super.onInit();
  }

  @override
  void onClose() {
    isDisposed = true;
    reviewController.dispose();
    betterPlayerController.value?.dispose();
    betterPlayerController.value = null;
    super.dispose();
  }
}
