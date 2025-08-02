import 'package:better_help/screen/auth_screen/change_password_screen/change_password_screen.dart';
import 'package:better_help/screen/auth_screen/complete_profile_screen/complete_profile_screen.dart';
import 'package:better_help/screen/auth_screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:better_help/screen/auth_screen/login_screen/login_screen.dart';
import 'package:better_help/screen/auth_screen/otp_verification_screen/otp_verification_screen.dart';
import 'package:better_help/screen/auth_screen/signup_screen/signup_screen.dart';
import 'package:better_help/screen/home_screen/home_screen.dart';
import 'package:better_help/screen/onboarding_screen/onbarding_screen.dart';
import 'package:better_help/screen/questionnaries_screen/questionnaries_screen.dart';
import 'package:better_help/screen/splash_screen/splash_screen.dart';
import 'package:better_help/screen/subscription/subscription_and_payment.dart';
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

  static List<GetPage> appRoutes = [
    //! Splash Screen Route
    GetPage(
      name: AppRoute.splashscreen,
      page: () => const SplashScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Onboarding Screen Route
    GetPage(
      name: AppRoute.onboardingscreen,
      page: () => const OnbardingScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Subscription Screen Route
    GetPage(
      name: AppRoute.subscriptionscreen,
      page: () => const SubscriptionAndPayment(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Questionnaries Screen Route
    GetPage(
      name: AppRoute.questionariescreen,
      page: () => const QuestionnariesScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Login Screen Route
    GetPage(
      name: AppRoute.loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Signup Screen Route
    GetPage(
      name: AppRoute.signupScreen,
      page: () => const SignupScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Forgot Password Screen Route
    GetPage(
      name: AppRoute.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! OTP Verification Screen Route
    GetPage(
      name: AppRoute.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Change Password Screen Route
    GetPage(
      name: AppRoute.changePasswrodScreen,
      page: () => const ChangePasswordScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Complete Profile Screen Route
    GetPage(
      name: AppRoute.completeProfileScreen,
      page: () => const CompleteProfileScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Home Screen Route
    GetPage(
      name: AppRoute.homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
