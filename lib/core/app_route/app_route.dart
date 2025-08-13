import 'package:better_help/screen/auth_screen/change_password_screen/change_password_screen.dart';
import 'package:better_help/screen/auth_screen/complete_profile_screen/complete_profile_screen.dart';
import 'package:better_help/screen/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:better_help/screen/auth_screen/login_screen/login_screen.dart';
import 'package:better_help/screen/auth_screen/otp_verification_screen/otp_verification_screen.dart';
import 'package:better_help/screen/auth_screen/signup_screen/signup_screen.dart';
import 'package:better_help/screen/bottom_nav/bottom_nav_screen.dart';
import 'package:better_help/screen/community_sections/main_community/community_screen.dart';
import 'package:better_help/screen/habits_sections/home_screen.dart';
import 'package:better_help/screen/habits_sections/main_habits/habits_screen.dart';
import 'package:better_help/screen/habits_sections/my_task/my_task.dart';
import 'package:better_help/screen/habits_sections/timer_screen/timer_screen.dart';
import 'package:better_help/screen/learn_sections/categories_screen/categories_screen.dart';
import 'package:better_help/screen/learn_sections/main_learn/learn_screen.dart';
import 'package:better_help/screen/learn_sections/trending_course/tranding_course.dart';
import 'package:better_help/screen/menu_drawer/bookings_sessions/bookings_sessions_screen.dart';
import 'package:better_help/screen/menu_drawer/calendar/calendar_task_screen.dart';
import 'package:better_help/screen/menu_drawer/faqs/faqs_screen.dart';
import 'package:better_help/screen/menu_drawer/favorite_course/favorite_course_screen.dart';
import 'package:better_help/screen/menu_drawer/my_subscription/my_subscription_screen.dart';
import 'package:better_help/screen/menu_drawer/privacy_policy/privacy_policy_screen.dart';
import 'package:better_help/screen/menu_drawer/saved_article/saved_article_screen.dart';
import 'package:better_help/screen/menu_drawer/talk_to_support/talk_to_support_screen.dart';
import 'package:better_help/screen/menu_drawer/terms_conditions/terms_conditions_screen.dart';
import 'package:better_help/screen/menu_drawer/user_drawer/user_drawer.dart';
import 'package:better_help/screen/onboarding_screen/onbarding_screen.dart';
import 'package:better_help/screen/progress_sections/main_progress/progress_screen.dart';
import 'package:better_help/screen/questionnaries_screen/questionnaries_screen.dart';
import 'package:better_help/screen/splash_screen/splash_screen.dart';
import 'package:better_help/screen/subscription/subscription_and_payment.dart';
import 'package:better_help/screen/supports_sections/main_supports/support_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  AppRoute._();
  static const String splashscreen = '/splashscreen';
  static const String onboardingscreen = '/onboardingscreen';
  static const String subscriptionscreen = '/subscriptionscreen';
  static const String homescreen = '/homescreen';
  static const String questionariescreen = '/questionariescreen';

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

  //! User Menu Drawer Screen Route
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

  //! Get Pages for all the Screen
  static List<GetPage> appRoutes = [
    //! Splash Screen Route
    GetPage(
      name: AppRoute.splashscreen,
      page: () => const SplashScreen(),
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
    //! Subscription Screen Route
    GetPage(
      name: AppRoute.subscriptionscreen,
      page: () => const SubscriptionAndPayment(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Questionnaries Screen Route
    GetPage(
      name: AppRoute.questionariescreen,
      page: () => const QuestionnariesScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Login Screen Route
    GetPage(
      name: AppRoute.loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
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
    ),
    //! OTP Verification Screen Route
    GetPage(
      name: AppRoute.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Change Password Screen Route
    GetPage(
      name: AppRoute.changePasswrodScreen,
      page: () => const ChangePasswordScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Complete Profile Screen Route
    GetPage(
      name: AppRoute.completeProfileScreen,
      page: () => const CompleteProfileScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Home Screen Route
    GetPage(
      name: AppRoute.homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Bottom Navigation Screen Route
    GetPage(
      name: AppRoute.bottomNav,
      page: () => const BottomNavScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Habits Screen Route
    GetPage(
      name: AppRoute.habitsScreen,
      page: () => const HabitsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Community Screen Route
    GetPage(
      name: AppRoute.communityScreen,
      page: () => const CommunityScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Learning Screen Route
    GetPage(
      name: AppRoute.learnScreen,
      page: () => const LearnScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Support Screen Route
    GetPage(
      name: AppRoute.supportScreen,
      page: () => const SupportScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Progress Screen Route
    GetPage(
      name: AppRoute.progressScreen,
      page: () => const ProgressScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! TimerScreen Screen Route
    GetPage(
      name: AppRoute.timerScreen,
      page: () => TimerScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! My Task Screen Route
    GetPage(
      name: AppRoute.mytask,
      page: () => MyTaskScreeen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! All Categories screen
    GetPage(
      name: AppRoute.allCategoriesScreen,
      page: () => CategoriesScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    //! Trending course scree
    GetPage(
      name: AppRoute.trendingCourse,
      page: () => TrandingCourse(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(microseconds: 300),
    ),
    //! Menu Drawer Page
    GetPage(
      name: AppRoute.userMenuDrawerScreen,
      page: () => UserDrawer(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! Menu Drawer Page
    GetPage(
      name: AppRoute.bookingsSessions,
      page: () => BookingsSessionsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! calendar taks screen
    GetPage(
      name: AppRoute.calendartaskscreen,
      page: () => CalendarTaskScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! faqs screen
    GetPage(
      name: AppRoute.faqsScreen,
      page: () => FaqsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! favrite course screen
    GetPage(
      name: AppRoute.favriteScreen,
      page: () => FavoriteCourseScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! my subscription screen
    GetPage(
      name: AppRoute.mySubscriptionScreen,
      page: () => MySubscriptionScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! privacy policy screen
    GetPage(
      name: AppRoute.privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! saved article screen
    GetPage(
      name: AppRoute.savedArticleScreen,
      page: () => SavedArticleScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! talk to support screen
    GetPage(
      name: AppRoute.talkToSupportScreen,
      page: () => TalkToSupportScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
    //! terms and conditions screen
    GetPage(
      name: AppRoute.termsAndConditionsScreen,
      page: () => TermsConditionsScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 400),
    ),
  ];
}
