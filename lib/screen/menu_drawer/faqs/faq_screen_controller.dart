/*
 * @Author: Km Muzahid
 * @Date: 2026-01-27 17:12:47
 * @Email: km.muzahid@gmail.com
 */
import 'package:better_help/core/app_apiurl/api_end_points.dart';
import 'package:core_kit/core_kit.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class FaqScreenController extends GetxController {
  RxList<MapEntry<String, String>> faqList = <MapEntry<String, String>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchFaqList();
    super.onInit();
  }

  fetchFaqList({int page = 1, bool isRefresh = false}) async {
    if (isRefresh) {
      faqList.clear();
    }
    isLoading.value = true;
    final result = await DioService.instance.request<List<MapEntry<String, String>>>(
      input: RequestInput(
        endpoint: ApiEndPoints.faq,
        method: RequestMethod.GET,
        queryParams: {"page": page, "limit": 20},
      ),
      responseBuilder: (response) {
        return (response as List)
            .map((e) => MapEntry(e['question']?.toString() ?? '', e['answer']?.toString() ?? ''))
            .toList();
      },
    );
    isLoading.value = false;

    if (result.isSuccess) {
      faqList.addAll(result.data ?? []);
    }
  }
}
