import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:carousel_slider/carousel_controller.dart';
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
    AppStaticImages.habits01,
    AppStaticImages.habits02,
    AppStaticImages.habits03,
    AppStaticImages.habits04,
  ];

  // Category data
  List<String> get categoryImages => [
    AppStaticImages.relationshipGuidance,
    AppStaticImages.stressManagements,
    AppStaticImages.healthyHabits,
    AppStaticImages.selfCareDevelopment,
    AppStaticImages.relationshipGuidance,
    AppStaticImages.stressManagements,
    AppStaticImages.healthyHabits,
    AppStaticImages.selfCareDevelopment,
  ];

  List<String> get categoryNames => [
    "Relationship Guidance",
    "Stress Management",
    "Healthy Habits",
    "Self Care Development",
    "Relationship Guidance",
    "Stress Management",
    "Healthy Habits",
    "Self Care Development",
  ];

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
}
