import 'package:core_kit/core_kit_internal.dart';
import 'package:core_kit/snackbar/ck_snackbar.dart';

class AppSnackBar {
  /// Show error snackbar without context (uses scaffoldMessengerKey)
  static void showError(String message, {String title = 'Error'}) {
    CkSnackBar(message, type: .error);
  }

  /// Show success snackbar without context (uses scaffoldMessengerKey)
  static void showSuccess(String message, {String title = 'Success'}) {
    CkSnackBar(message, type: .success);
  }

  /// Show warning snackbar without context (uses scaffoldMessengerKey)
  static void showWarning(String message, {String title = 'Warning'}) {
    CkSnackBar(message, type: .warning);
  }
}
