import 'package:get/get.dart';

import '../../screen/menu_drawer/bookings_sessions/controller/bookings_sessions_controller.dart';
import '../../screen/menu_drawer/favorite_course/controller/favorite_course_controller.dart';
import '../../screen/menu_drawer/my_profile/edit_profile_screen/controller/edit_profile_contrller.dart';
import '../../screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import '../../screen/menu_drawer/saved_article/controller/saved_article_controller.dart';
import '../../utils/app_log/app_log.dart';

class MenuBindings extends Bindings {
  @override
  void dependencies() {
    //! Bookings Sessions Controller
    Get.lazyPut<BookingsSessionsController>(() {
      appLog("Booking Seesing Controller is Initialized");
      return BookingsSessionsController();
    }, fenix: true);

    //! Favorite Course Controller
    Get.lazyPut<FavoriteCourseController>(() {
      appLog("Favorite Course Controller is Initialized");
      return FavoriteCourseController();
    }, fenix: true);

    //! Edit Profile Controller
    Get.lazyPut<EditProfileContrller>(() {
      appLog("Edit Profile Controller is Initialized");
      return EditProfileContrller();
    }, fenix: true);

    //! My Profile Screen Controller
    Get.lazyPut<MyProfileScreenController>(() {
      appLog("My Profile Screen Controller is Initialized");
      return MyProfileScreenController();
    }, fenix: true);

    //! Saved Article Controller
    Get.lazyPut<SavedArticleController>(() {
      appLog("Saved Article Controller is Initialized");
      return SavedArticleController();
    }, fenix: true);
  }
}
