/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 09:41:39
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:better_help/screen/learn_sections/main_learn/model/category_model.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class CategoriesScreenController extends GetxController {
  final Debouncer debouncer = Debouncer(delay: Duration(milliseconds: 500));

  TextEditingController searchController = TextEditingController();

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  String lastSearchTerm = '';

  void fetchCategory({String? searchTerm}) async {
    final response = await DioService.instance.request(
      input: RequestInput(
        queryParams: {
          "page": 1,
          if (searchTerm?.isNotEmpty == true) "searchTerm": searchTerm,
          "limit": 100,
        },
        endpoint: ApiEndPoints.getCourseCategoryList,
        method: RequestMethod.GET,
      ),
      responseBuilder: (data) => (data as List).map((e) => CategoryModel.fromJson(e)).toList(),
    );

    if (response.isSuccess) {
      final data = response.data;
      categoryList.assignAll(data ?? []);
    }
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      debouncer.call(() {
        if (lastSearchTerm == searchController.text) {
          return;
        }
        lastSearchTerm = searchController.text;
        categoryList.clear();
        fetchCategory(searchTerm: searchController.text.isEmpty ? null : searchController.text);
      });
    });
    fetchCategory();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
