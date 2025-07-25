import 'package:better_help/screen/onboarding_screen/onbarding_screen.dart';
import 'package:better_help/screen/splash_screen/splash_screen.dart';
import 'package:better_help/screen/subscription/subscription_and_payment.dart';
import 'package:get/get.dart';

class AppRoute {
  AppRoute._();
  static const String splashscreen = '/splashscreen';
  static const String onboardingscreen = '/onboardingscreen';
  static const String subscriptionscreen = '/subscriptionscreen';
  static const String homescreen = '/homescreen';

  static List<GetPage> appRoutes = [
    //! Splash Screen Route 
    GetPage(
      name: AppRoute.splashscreen,
      page: () => const SplashScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    //! Onboarding Screen Route
    GetPage(name: AppRoute.onboardingscreen,
    page: () => const OnbardingScreen(),
    transition: Transition.rightToLeftWithFade,
    ),
    //! Subscription Screen Route
    GetPage(
      name: AppRoute.subscriptionscreen,
      page: () => const SubscriptionAndPayment(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
