import 'package:better_help/screen/habits_sections/main_habits/controller/generate_task_based_on_preferense_controller.dart';
import 'package:better_help/screen/menu_drawer/faqs/faq_screen_controller.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/controller/my_profile_screen_controller.dart';
import 'package:better_help/screen/menu_drawer/privacy_policy/privacy_policy_screen_controller.dart';
import 'package:better_help/screen/menu_drawer/talk_to_support/talk_to_support_screen_controller.dart';
import 'package:better_help/screen/menu_drawer/terms_conditions/terms_and_conditions_screen_controller.dart';
import 'package:better_help/screen/notification/notification_screen_controller.dart';
import 'package:get/get.dart';

import '../../screen/auth_screen/signup_screen/controller/singup_screen_controller.dart';
import '../../screen/onboarding_screen/controller/onboarding_screen_controller.dart';
import '../../screen/questionnaries_screen/controller/questionnaries_screen_controller.dart';
import '../../service/connectivity_service/connectivity_services.dart';
import '../../utils/app_log/app_log.dart';

class AppInitialBindings implements Bindings {
  @override
  void dependencies() {
    //! Internet Connection Checked Screen
    // Get.lazyPut<ConnectivityService>(() {
    //   appLog('Registering ConnectivityService');
    //   return ConnectivityService();
    // }, fenix: true);

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

    Get.lazyPut<NotificationScreenController>(() {
      appLog('Registering NotificationScreenController');
      return NotificationScreenController();
    }, fenix: true);

    Get.lazyPut<FaqScreenController>(() {
      appLog('Registering FaqScreenController');
      return FaqScreenController();
    }, fenix: true);

    Get.lazyPut<TalkToSupportScreenController>(() {
      appLog('Registering TalkToSupportScreenController');
      return TalkToSupportScreenController();
    }, fenix: true);

    Get.lazyPut<TermsAndConditionsScreenController>(() {
      appLog('Registering TermsAndConditionsScreenController');
      return TermsAndConditionsScreenController();
    }, fenix: true);

    Get.lazyPut<PrivacyPolicyScreenController>(() {
      appLog('Registering PrivacyPolicyScreenController');
      return PrivacyPolicyScreenController();
    }, fenix: true);

    Get.lazyPut<GenerateTaskBasedOnPreferenceController>(() {
      appLog('Registering GenerateTaskBasedOnPreferenceController');
      return GenerateTaskBasedOnPreferenceController();
    }, fenix: true);
  }
}
