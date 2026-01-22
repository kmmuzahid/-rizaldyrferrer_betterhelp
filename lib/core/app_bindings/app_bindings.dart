import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:get/get.dart';

import '../../screen/auth_screen/signup_screen/controller/singup_screen_controller.dart';
import '../../screen/onboarding_screen/controller/onboarding_screen_controller.dart';
import '../../screen/questionnaries_screen/controller/questionnaries_screen_controller.dart';
import '../../screen/splash_screen/controller/splash_screen_controller.dart';
import '../../service/connectivity_service/connectivity_services.dart';
import '../../utils/app_log/app_log.dart';

class AppInitialBindings implements Bindings {
  @override
  void dependencies() {
    //! Internet Connection Checked Screen
    Get.lazyPut<ConnectivityService>(() {
      appLog('Registering ConnectivityService');
      return ConnectivityService();
    }, fenix: true);

    //! SlpashScreen Contrlloer
    Get.lazyPut<SplashScreenController>(() {
      appLog('Registering SplashScreenController');
      return SplashScreenController();
    }, fenix: true);

    //! Onboarding Screen Controller
    Get.lazyPut<OnboardingScreenController>(() {
      appLog('Registering OnboardingScreenController');
      return OnboardingScreenController();
    }, fenix: true);

    //! Questionnaries Screen Controller
    Get.lazyPut<QuestionnariesScreenController>(
      () {
        appLog('Registering QuestionnariesScreenController');
        return QuestionnariesScreenController();
      },
      fenix: true,
      tag: 'questionnaires',
    );

    //! Signup Screen Controller
    Get.lazyPut<SingupScreenController>(() {
      appLog('Registering SingupScreenController');
      return SingupScreenController();
    }, fenix: true);
  
    Get.lazyPut<MyProfileScreenController>(() {
      appLog('Registering MyProfileScreenController');
      return MyProfileScreenController();
    }, fenix: true);
 
  }


}
