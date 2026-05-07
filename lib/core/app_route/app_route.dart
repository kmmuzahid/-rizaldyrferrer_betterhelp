import 'package:better_help/core/app_internet_check/app_interner_check.dart';
import 'package:better_help/screen/auth_screen/change_password_screen/change_password_screen.dart';
import 'package:better_help/screen/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:better_help/screen/auth_screen/login_screen/login_screen.dart';
import 'package:better_help/screen/auth_screen/otp_verification_screen/otp_verification_screen.dart';
import 'package:better_help/screen/auth_screen/signup_screen/signup_screen.dart';
import 'package:better_help/screen/booking_screen/booking_screen.dart';
import 'package:better_help/screen/bottom_nav/bottom_nav_screen.dart';
import 'package:better_help/screen/community_sections/creating_post/creating_post.dart';
import 'package:better_help/screen/community_sections/main_community/community_screen.dart';
import 'package:better_help/screen/free_trial_screen/free_trial_screen.dart';
import 'package:better_help/screen/habits_sections/home_screen.dart';
import 'package:better_help/screen/habits_sections/main_habits/habits_screen.dart';
import 'package:better_help/screen/habits_sections/my_task/my_task.dart';
import 'package:better_help/screen/habits_sections/timer_screen/timer_screen.dart';
import 'package:better_help/screen/learn_sections/article_details/articles_details.dart';
import 'package:better_help/screen/learn_sections/categories_screen/categories_screen.dart';
import 'package:better_help/screen/learn_sections/main_learn/learn_screen.dart';
import 'package:better_help/screen/learn_sections/trending_course/tranding_course.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/bookings_sessions_screen.dart';
import 'package:better_help/screen/menu_drawer/calendar/calendar_task_screen.dart';
import 'package:better_help/screen/menu_drawer/faqs/faqs_screen.dart';
import 'package:better_help/screen/menu_drawer/favorite_course/favorite_course_screen.dart';
import 'package:better_help/screen/menu_drawer/my_profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:better_help/screen/menu_drawer/my_profile/profile_screen/my_profle_screen.dart';
import 'package:better_help/screen/menu_drawer/my_subscription/my_subscription_screen.dart';
import 'package:better_help/screen/menu_drawer/privacy_policy/privacy_policy_screen.dart';
import 'package:better_help/screen/menu_drawer/saved_article/saved_article_screen.dart';
import 'package:better_help/screen/menu_drawer/talk_to_support/talk_to_support_screen.dart';
import 'package:better_help/screen/menu_drawer/terms_conditions/terms_conditions_screen.dart';
import 'package:better_help/screen/menu_drawer/user_drawer/user_drawer.dart';
import 'package:better_help/screen/no_internet_screen/no_internet_screen.dart';
import 'package:better_help/screen/notification/notification_screen.dart';
import 'package:better_help/screen/onboarding_screen/onbarding_screen.dart';
import 'package:better_help/screen/progress_sections/main_progress/progress_screen.dart';
import 'package:better_help/screen/questionnaries_screen/questionnaries_screen.dart';
import 'package:better_help/screen/questionnaries_screen/widgets/analyze_screen.dart';
import 'package:better_help/screen/report_problem/report_problem_screen.dart';
import 'package:better_help/screen/splash_screen/splash_screen.dart';
import 'package:better_help/screen/subscription/subscription_and_payment.dart';
import 'package:better_help/screen/supports_sections/main_supports/support_screen.dart';
import 'package:better_help/screen/supports_sections/video_call_agora/video_call_screen.dart';
import 'package:better_help/widget/app_confeti/habit_complete_screen.dart';
import 'package:better_help/screen/habits_sections/main_habits/generate_task_based_on_preference_screen.dart';
import 'package:get/get.dart';

import '../../screen/before_question_screen/before_question_screen.dart';
import '../../screen/course_details/corse_details_screen.dart';
import '../../screen/free_trial_screen/free_trial_enroll.dart';
import '../../screen/questionnaries_screen/questionnaire_summary_screen.dart';
import '../app_bindings/community_bindings.dart';
import '../app_bindings/habit_bindings.dart';
import '../app_bindings/learn_bindings.dart';
import '../app_bindings/menu_bindings.dart';
import '../app_bindings/support_bindings.dart';

class AppRoute {
  AppRoute._();
  static const String splashscreen = '/splashscreen';
  static const String onboardingscreen = '/onboardingscreen';
  static const String subscriptionscreen = '/subscriptionscreen';
  static const String homescreen = '/homescreen';
  static const String questionariescreen = '/questionariescreen';
  static const String questionnaireSummaryScreen =
      '/questionnaireSummaryScreen';
  static const String beforeQuestionScreen = '/beforeQuestionScreen';
  static const String freeTrialScreen = "/freeTrialScreen";
  static const String freeTrialEnrollScreen = "/freeTrialEnrollScreen";
  static const String noInternetScreen = "/noInternetScreen";

  //! Authentication Screen Route
  static const String loginScreen = '/loginScreen';
  static const String signupScreen = '/signupscreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String otpVerificationScreen = '/otpVerificationScreen';
  static const String changePasswrodScreen = '/changePasswrodScreen';
  static const String completeProfileScreen = '/completeProfileScreen';
  static const String homeScreen = '/homeScreen';

  //! Bottom Navigation Screen Route
  static const String bottomNav = '/bottomNav';
  static const String habitsScreen = '/habitsScreen';
  static const String communityScreen = '/communityScreen';
  static const String learnScreen = '/learningScreen';
  static const String supportScreen = '/supportScreen';
  static const String progressScreen = '/progressScreen';
  //! Habit Screen Route
  static const String timerScreen = '/timerScreen';
  static const String mytask = "/mytask";
  static const String trendingCourse = "/trendingCOUrse";

  //! Learn Screen Route
  static const String allCategoriesScreen = '/allCategoriesScreen';
  static const String courseScreen = '/courseScreen';
  static const String courseDetailScreen = '/courseDetailScreen';
  static const String articleScreen = '/articleScreen';

  //! User Menu Drawer Screen Route
  static const String myProfileScreen = '/myProfileScreen';
  static const String userMenuDrawerScreen = '/userMenuDrawerScreen';
  static const String bookingsSessions = "/bookingsessions";
  static const String calendartaskscreen = "/calendartaskscreen";
  static const String faqsScreen = "/faqsScreen";
  static const String favriteScreen = "/favriteScreen";
  static const String mySubscriptionScreen = "/mySubscriptionScreen";
  static const String privacyPolicyScreen = "/privacyPolicyScreen";
  static const String savedArticleScreen = "/savedArticleScreen";
  static const String talkToSupportScreen = "/talkToSupportScreen";
  static const String termsAndConditionsScreen = "/termsAndConditionsScreen";
  static const String videoCallScreen = "/videoCallScreen";
  static const String notificationScreen = "/notificationScreen";

  //! Community Screen Route
  static const String creatingPost = "/creatingpost";
  static const String singlePostScreen = "/singlePostScreen";

  //! Congratulation Screen
  static const String congratulationScreen = "/congratulationScreen";

  static const String bookingScreen = "/bookingScreen";
  static const String reportProblemScreen = "/reportProblemScreen";
  static const String analyzeScreen = "/analyzeScreen";
  static const String generateTaskBasedOnPreference = "/generateTaskBasedOnPreference";

  //! Get Pages for all the Screen

  static List<GetPage> appRoutes = [
    //! Splash Screen Route
    GetPage(
      name: AppRoute.splashscreen,
      page: () => SplashScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),

    //! Report Problem Screen Route
    GetPage(
      name: AppRoute.reportProblemScreen,
      page: () => ReportProblemScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),

    //! Booking Screen Route
    GetPage(
      name: AppRoute.bookingScreen,
      page: () => BookingScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Analyze Screen Route
    GetPage(
      name: AppRoute.analyzeScreen,
      page: () => AnalyzingScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Onboarding Screen Route
    GetPage(
      name: AppRoute.onboardingscreen,
      page: () => const OnbardingScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Free Trial Screen Route
    GetPage(
      name: AppRoute.notificationScreen,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoute.freeTrialScreen,
      page: () => FreeTrialScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Free Trail Enroll Screen Route
    GetPage(
      name: AppRoute.freeTrialEnrollScreen,
      page: () => FreeTrialEnrollScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Subscription Screen Route
    GetPage(
      name: AppRoute.subscriptionscreen,
      page: () => const SubscriptionAndPayment(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Before Question Screen Route
    GetPage(
      name: AppRoute.beforeQuestionScreen,
      page: () => BeforeQuestionScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Questionnaries Screen Route
    GetPage(
      name: AppRoute.questionariescreen,
      page: () => const QuestionnariesScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Questionnaire Summary Screen Route
    GetPage(
      name: AppRoute.questionnaireSummaryScreen,
      page: () => const QuestionnaireSummaryScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! No Internet Screen
    GetPage(
      name: AppRoute.noInternetScreen,
      page: () => NoInternetScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Login Screen Route
    GetPage(
      name: AppRoute.loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Signup Screen Route
    GetPage(
      name: AppRoute.signupScreen,
      page: () => const SignupScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Forgot Password Screen Route
    GetPage(
      name: AppRoute.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! OTP Verification Screen Route
    GetPage(
      name: AppRoute.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Change Password Screen Route
    GetPage(
      name: AppRoute.changePasswrodScreen,
      page: () => const ChangePasswordScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Complete Profile Screen Route
    GetPage(
      name: AppRoute.completeProfileScreen,
      page: () => const CompleteProfileScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Home Screen Route
    GetPage(
      name: AppRoute.homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Bottom Navigation Screen Route
    GetPage(
      name: AppRoute.bottomNav,
      page: () => const BottomNavScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: BindingsBuilder(() {
        CommunityBindings().dependencies();
        HabitBindings().dependencies();
        LearnBindings().dependencies();
        SupportBindings().dependencies();
        MenuBindings().dependencies();
      }),
      middlewares: [AppInternerCheck()],
    ),
    //! Habits Screen Route
    GetPage(
      name: AppRoute.habitsScreen,
      page: () => const HabitsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: BindingsBuilder(() {
        HabitBindings().dependencies();
        MenuBindings().dependencies();
      }),
      middlewares: [AppInternerCheck()],
    ),
    GetPage(
      name: AppRoute.generateTaskBasedOnPreference,
      page: () => const GenerateTaskBasedOnPreferenceScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! Community Screen Route
    GetPage(
      name: AppRoute.communityScreen,
      page: () => const CommunityScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: CommunityBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Learning Screen Route
    GetPage(
      name: AppRoute.learnScreen,
      page: () => const LearnScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: LearnBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Article Details Screen Route
    GetPage(
      name: AppRoute.articleScreen,
      page: () => const ArticlesDetailsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: LearnBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Community Screen Route
    GetPage(
      name: AppRoute.creatingPost,
      page: () => const CreatingPostScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: CommunityBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Support Screen Route
    GetPage(
      name: AppRoute.supportScreen,
      page: () => const SupportScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: SupportBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Progress Screen Route
    GetPage(
      name: AppRoute.progressScreen,
      page: () => const ProgressScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AppInternerCheck()],
    ),
    //! TimerScreen Screen Route
    GetPage(
      name: AppRoute.timerScreen,
      page: () => TimerScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
      binding: HabitBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! My Task Screen Route
    GetPage(
      name: AppRoute.mytask,
      page: () => MyTaskScreeen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: HabitBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! All Categories screen
    GetPage(
      name: AppRoute.allCategoriesScreen,
      page: () => CategoriesScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: LearnBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Trending course scree
    GetPage(
      name: AppRoute.trendingCourse,
      page: () => TrandingCourse(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(microseconds: 300),
      binding: LearnBindings(),
      middlewares: [AppInternerCheck()],
    ),
    GetPage(
      name: AppRoute.courseDetailScreen,
      page: () => CourseDetailScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(microseconds: 300),
      binding: LearnBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Menu Drawer Page
    GetPage(
      name: AppRoute.userMenuDrawerScreen,
      page: () => UserDrawer(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Menu My Profile Screen
    GetPage(
      name: AppRoute.myProfileScreen,
      page: () => MyProfleScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! Menu Drawer Page
    GetPage(
      name: AppRoute.bookingsSessions,
      page: () => BookingsSessionsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! calendar taks screen
    GetPage(
      name: AppRoute.calendartaskscreen,
      page: () => CalendarTaskScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! faqs screen
    GetPage(
      name: AppRoute.faqsScreen,
      page: () => FaqsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! favrite course screen
    GetPage(
      name: AppRoute.favriteScreen,
      page: () => FavoriteCourseScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! my subscription screen
    GetPage(
      name: AppRoute.mySubscriptionScreen,
      page: () => MySubscriptionScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! privacy policy screen
    GetPage(
      name: AppRoute.privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! saved article screen
    GetPage(
      name: AppRoute.savedArticleScreen,
      page: () => SavedArticleScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! talk to support screen
    GetPage(
      name: AppRoute.talkToSupportScreen,
      page: () => TalkToSupportScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! terms and conditions screen
    GetPage(
      name: AppRoute.termsAndConditionsScreen,
      page: () => TermsConditionsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: MenuBindings(),
      middlewares: [AppInternerCheck()],
    ),
    //! congratulation screen
    GetPage(
      name: AppRoute.congratulationScreen,
      page: () => CongratulationScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      middlewares: [AppInternerCheck()],
    ),
    //! video call screen
    GetPage(
      name: AppRoute.videoCallScreen,
      page: () => VideoCallScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
      binding: SupportBindings(),
      middlewares: [AppInternerCheck()],
    ),
  ];
}
