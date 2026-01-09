import 'package:better_help/core/app_apiurl/app_apiurl.dart';
import 'package:better_help/screen/learn_sections/main_learn/model/category_model.dart';
import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:core_kit/network/dio_service.dart';
import 'package:core_kit/network/request_input.dart';
import 'package:get/get.dart';

class LearnScreenController extends GetxController {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentIndex = 0.obs;

  // Quote data
  List<String> get quoteList => [
    AppString.quotes01,
    AppString.quotes02,
    AppString.quotes03,
    AppString.quotes04,
  ];

  List<String> get quoteAuthorList => [
    AppString.quotes01Author,
    AppString.quotes02Author,
    AppString.quotes03Author,
    AppString.quotes04Author,
  ];

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

  // Category data
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;


  // Trending courses data
  List<String> get trendingCourseImages => [
    AppStaticImages.habits01,
    AppStaticImages.habits02,
    AppStaticImages.habits03,
    AppStaticImages.habits04,
  ];

  List<String> get trendingCourseTitles => [
    "Overcoming Workplace Anxiety",
    "Building Healthy Relationships",
    "Stress Management Techniques",
    "Self-Care Development",
  ];

  List<String> get trendingCourseInstructors => [
    "Dr. Rizaldy Ferrer",
    "Dr. Sarah Johnson",
    "Dr. Michael Chen",
    "Dr. Emily Davis",
  ];

  List<double> get trendingCourseRatings => [4.3, 4.5, 4.2, 4.7];

  List<String> get trendingCourseViews => [
    "2,453 View",
    "3,821 View",
    "1,967 View",
    "4,102 View",
  ];

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

  @override
  void onInit() {
    fetchCategory();
    super.onInit();
  }
}
