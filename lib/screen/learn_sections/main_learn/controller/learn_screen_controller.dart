/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/learn_sections/main_learn/model/category_model.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

import '../model/course_model.dart';

class LearnScreenController extends GetxController {
  final CarouselSliderController carouselController = CarouselSliderController();
  var currentIndex = 0.obs;

  List<String> get backgroundImages => [
    AppStaticImages.dailyAffermation01,
    AppStaticImages.dailyAffermation02,
    AppStaticImages.dailyAffermation03,
    AppStaticImages.dailyAffermation04,
    AppStaticImages.dailyAffermation05,
    AppStaticImages.dailyAffermation06,
    AppStaticImages.dailyAffermation07,
    AppStaticImages.dailyAffermation08,
  ].obs;
 
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<CourseModel> recentCourseList = <CourseModel>[].obs;
  RxList<CourseModel> trendingCourseList = <CourseModel>[].obs;

  // Method to update current index
  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  // Method to go to specific slide
  void goToSlide(int index) {
    carouselController.animateToPage(index);
  }

  // Method to go to next slide
  void nextSlide() {
    carouselController.nextPage();
  }

  // Method to go to previous slide
  void previousSlide() {
    carouselController.previousPage();
  }

  void fetchCategory() async {
    final response = await DioService.instance.request(
      input: RequestInput(
        queryParams: {"page": 1, "limit": 10},
        endpoint: AppApiurl.getCourseCategoryList,
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => (data as List).map((e) => CategoryModel.fromJson(e)).toList(),
    );

    if (response.isSuccess) {
      final data = response.data;
      categoryList.assignAll(data ?? []);
    }
  }

  void fetchRecentCourse() async {
    
    final response = await DioService.instance.request(
      // showMessage: true,
      input: RequestInput(
        queryParams: {"page": 1, "limit": 10},
        endpoint: AppApiurl.getCourseList,
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => (data as List).map((e) => CourseModel.fromJson(e)).toList(),
    );
    if (response.isSuccess) {
      final data = response.data;
      recentCourseList.assignAll(data ?? []);
    }
  }

  void fetchTrendingCourse() async {
    final response = await DioService.instance.request(
      input: RequestInput(
        queryParams: {"page": 1, "limit": 10, "trending": true},
        endpoint: AppApiurl.getCourseList,
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => (data as List).map((e) => CourseModel.fromJson(e)).toList(),
    );

    if (response.isSuccess) {
      final data = response.data;
      trendingCourseList.assignAll(data ?? []);
    }
  }

  toggleFavouriteTrending(int index) async {
    final course = trendingCourseList[index];
    final result = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: AppApiurl.favoriteCourse,
        method: RequestMethod.POST,
        jsonBody: {"courseId": course.id},
      ),
      responseBuilder: (data) => data,
    );
    if (result.isSuccess) {
      trendingCourseList[index] = course.copywith(isFavorite: !course.isFavorite);
    }
  }

  toggleFavouriteRecent(int index) async {
    final course = recentCourseList[index];
    final result = await DioService.instance.request(
      showMessage: true,
      input: RequestInput(
        endpoint: AppApiurl.favoriteCourse,
        method: RequestMethod.POST,
        jsonBody: {"courseId": course.id},
      ),
      responseBuilder: (data) => data,
    );
    if (result.isSuccess) {
      recentCourseList[index] = course.copywith(isFavorite: !course.isFavorite);
    }
  }

  @override
  void onInit() {
    fetchCategory();
    fetchTrendingCourse();
    fetchRecentCourse();
    super.onInit();
  }
}
