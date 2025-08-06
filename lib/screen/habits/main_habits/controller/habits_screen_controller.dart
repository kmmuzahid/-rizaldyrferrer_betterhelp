import 'package:better_help/utils/app_images/app_images.dart';
import 'package:better_help/utils/app_string/app_string.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class HabitsScreenController extends GetxController {
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

  @override
  void onClose() {
    // CarouselSliderController doesn't need manual disposal
    super.onClose();
  }
}
