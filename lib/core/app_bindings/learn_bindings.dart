import 'package:better_help/utils/app_log/app_log.dart';
import 'package:get/get.dart';

import '../../screen/learn_sections/main_learn/controller/learn_screen_controller.dart';
import '../../screen/learn_sections/categories_screen/controller/categories_screen_controller.dart';
import '../../screen/learn_sections/trending_course/controller/trending_course_controller.dart';
import '../../screen/community_sections/main_community/controller/article_details_screen_controller.dart';
import '../../screen/course_details/controller/course_details_control.dart';

class LearnBindings extends Bindings {
  @override
  void dependencies() {
    //! LearnScreenController is called when LearnScreen is opened
    Get.lazyPut<LearnScreenController>(() {
      appLog("LearnScreenController is initialized");
      return LearnScreenController();
    }, fenix: true);

    //! CategoriesScreenController is called when CategoriesScreen is opened
    Get.lazyPut<CategoriesScreenController>(() {
      appLog("CategoriesScreenController is initialized");
      return CategoriesScreenController();
    }, fenix: true);

    //! TrendingCourseController is called when TrendingCourseScreen is opened
    Get.lazyPut<TrendingCourseController>(() {
      appLog("TrendingCourseController is initialized");
      return TrendingCourseController();
    }, fenix: true);

    //! ArticleDetailsScreenController is called when ArticleDetailsScreen is opened
    Get.lazyPut<ArticleDetailsScreenController>(() {
      appLog("ArticleDetailsScreenController is initialized");
      return ArticleDetailsScreenController();
    }, fenix: true);

    //! CourseDetailsController is called when CourseDetailsScreen is opened
    Get.lazyPut<CourseDetailsController>(() {
      appLog("CourseDetailsController is initialized");
      return CourseDetailsController();
    }, fenix: true);
  }
}
