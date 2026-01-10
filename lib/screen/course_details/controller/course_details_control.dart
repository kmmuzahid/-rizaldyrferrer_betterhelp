import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/course_details/model/course_details_model.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailsController extends GetxController {
  // Observable state variables
  late String id;
  Rxn<CourseDetailsModel> courseDetails = Rxn<CourseDetailsModel>();
  final TextEditingController reviewController = TextEditingController();

  var selectedRating = 0.obs; // Tracks selected stars in the bottom sheet

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
    final result = await DioService.instance.request(
      input: RequestInput(endpoint: '${AppApiurl.getCourseList}/$id', method: RequestMethod.GET),
      responseBuilder: (response) {
        return CourseDetailsModel.fromJson(response);
      },
    );

    if (result.data != null) {
      courseDetails.value = result.data;
    }
  }

  @override
  void onInit() {
    id = Get.arguments['id'];
    fetchCourseDetails();
    super.onInit();
  }

  @override
  dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
