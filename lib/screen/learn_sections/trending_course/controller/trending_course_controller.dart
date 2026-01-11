/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/learn_sections/main_learn/model/course_model.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class TrendingCourseController extends GetxController {
  RxList<CourseModel> trendingCourseList = RxList<CourseModel>([]);
  bool isTrending = false;
  TextEditingController searchController = TextEditingController();
  String lastSearch = '';
  final Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 500));
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isTrending = Get.arguments == null ? false : Get.arguments['isTrending'] ?? false;
    fetchTrendingCourse(page: 1);
    searchController.addListener(() {
      debouncer.call(() {
        if (lastSearch != searchController.text) {
          trendingCourseList.clear();
          lastSearch = searchController.text;
          fetchTrendingCourse(
            searchQuery: searchController.text.isEmpty ? null : searchController.text,
            page: 1,
          );
        }
      });
    });
  }

  toggleFavoriteCourse(int index) async {
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

  fetchTrendingCourse({String? searchQuery, required int page}) async {
    isLoading.value = true;
    final result = await DioService.instance.request(
      input: RequestInput(
        queryParams: {
          "page": page,
          "limit": 10,
          if (isTrending) "trending": true,
          if (searchQuery != null) "searchTerm": searchQuery,
        },
        endpoint: AppApiurl.getCourseList,
        method: RequestMethod.GET,
      ),
      responseBuilder: (response) {
        return (response as List).map((e) => CourseModel.fromJson(e)).toList();
      },
    );
    if (result.data != null && result.data!.isNotEmpty) {
      page++;
      trendingCourseList.addAll(result.data!);
    }
    isLoading.value = false;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
