/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 17:05:17
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/course_details/model/course_details_model.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
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

  Rxn<BetterPlayerController> betterPlayerController = Rxn<BetterPlayerController>();

  initializePlayer() {
    if (courseDetails.value?.data.video == null) return;
    isPlay.value = false;
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      courseDetails.value!.data.video,
    );

    betterPlayerController.value = BetterPlayerController(
      const BetterPlayerConfiguration(),
      betterPlayerDataSource: dataSource,
    );

    Future.delayed(const Duration(seconds: 1)).then((value) {
      final d = betterPlayerController.value?.videoPlayerController?.value.duration;
      videoDuration.value = d != null ? CoreUtils.formatDurationToHms(d) : '00:00:00';
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
    DioService.instance.request(
      input: RequestInput(endpoint: AppApiurl.setCourseViewCount(id), method: RequestMethod.PATCH),
      responseBuilder: (response) {
        return response;
      },
    );
  }

  void updateRating(int rating) async {
    selectedRating.value = rating;
  }

  void submitFeedback() async {
    final result = await DioService.instance.request(
      input: RequestInput(
        endpoint: AppApiurl.review,
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
      showSnackBar(result.message ?? '', type: SnackBarType.success);
    } else {
      showSnackBar(result.message ?? '', type: SnackBarType.error);
    }
  }

  fetchCourseDetails() async {
    betterPlayerController.value?.dispose();
    final result = await DioService.instance.request(
      input: RequestInput(endpoint: '${AppApiurl.getCourseList}/$id', method: RequestMethod.GET),
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
