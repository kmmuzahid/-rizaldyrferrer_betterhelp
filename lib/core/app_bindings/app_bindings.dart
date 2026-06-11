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

class AppInitialBindings implements Binding {
  @override
  List<Bind<dynamic>> dependencies() {
    return [
      Bind.lazyPut<OnboardingScreenController>(() {
        appLog('Registering OnboardingScreenController');
        return OnboardingScreenController();
      }, fenix: true),

      //! Questionnaries Screen Controller
      Bind.lazyPut<QuestionnariesScreenController>(
        () {
          appLog('Registering QuestionnariesScreenController');
          return QuestionnariesScreenController();
        },
        fenix: true,
        tag: 'questionnaires',
      ),

      //! Signup Screen Controller
      Bind.lazyPut<SingupScreenController>(() {
        appLog('Registering SingupScreenController');
        return SingupScreenController();
      }, fenix: true),

      Bind.lazyPut<MyProfileScreenController>(() {
        appLog('Registering MyProfileScreenController');
        return MyProfileScreenController();
      }, fenix: true),

      Bind.lazyPut<NotificationScreenController>(() {
        appLog('Registering NotificationScreenController');
        return NotificationScreenController();
      }, fenix: true),

      Bind.lazyPut<FaqScreenController>(() {
        appLog('Registering FaqScreenController');
        return FaqScreenController();
      }, fenix: true),

      Bind.lazyPut<TalkToSupportScreenController>(() {
        appLog('Registering TalkToSupportScreenController');
        return TalkToSupportScreenController();
      }, fenix: true),

      Bind.lazyPut<TermsAndConditionsScreenController>(() {
        appLog('Registering TermsAndConditionsScreenController');
        return TermsAndConditionsScreenController();
      }, fenix: true),

      Bind.lazyPut<PrivacyPolicyScreenController>(() {
        appLog('Registering PrivacyPolicyScreenController');
        return PrivacyPolicyScreenController();
      }, fenix: true),

      Bind.lazyPut<GenerateTaskBasedOnPreferenceController>(() {
        appLog('Registering GenerateTaskBasedOnPreferenceController');
        return GenerateTaskBasedOnPreferenceController();
      }, fenix: true),
    ];
  }
}
