import 'package:get/get.dart';

import '../../screen/supports_sections/booking_session/controller/booking_session_controller.dart';
import '../../screen/supports_sections/main_supports/controller/support_screen_controller.dart';

class SupportBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportScreenController>(
      () => SupportScreenController(),
      fenix: true,
    );
    Get.lazyPut<BookingSessionController>(
      () => BookingSessionController(),
      fenix: true,
    );
  }
}
