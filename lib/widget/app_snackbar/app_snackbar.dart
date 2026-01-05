import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AppSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Show success snackbar
  static void success({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.success,
      duration: duration,
    );
  }

  /// Show failure snackbar
  static void failure({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
    );
  }

  /// Show error snackbar
  static void error({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.failure,
      duration: duration,
    );
  }

  /// Show warning snackbar
  static void warning({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.warning,
      duration: duration,
    );
  }

  /// Show help/info snackbar
  static void help({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
    );
  }

  /// Show info snackbar (alias for help)
  static void info({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.help,
      duration: duration,
    );
  }

  /// Private method to show snackbar
  static void _showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
    required Duration duration,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: duration,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show snackbar with custom content type
  static void custom({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      context: context,
      title: title,
      message: message,
      contentType: contentType,
      duration: duration,
    );
  }

  /// Quick success message (simple title only)
  static void quickSuccess(BuildContext context, String message) {
    success(context: context, title: 'Success!', message: message);
  }

  /// Quick error message (simple title only)
  static void quickError(BuildContext context, String message) {
    error(context: context, title: 'Error!', message: message);
  }

  /// Quick warning message (simple title only)
  static void quickWarning(BuildContext context, String message) {
    warning(context: context, title: 'Warning!', message: message);
  }

  /// Quick info message (simple title only)
  static void quickInfo(BuildContext context, String message) {
    info(context: context, title: 'Info', message: message);
  }

  /// Show snackbar for API response
  static void apiResponse({
    required BuildContext context,
    required bool isSuccess,
    String? successTitle,
    String? successMessage,
    String? errorTitle,
    String? errorMessage,
  }) {
    if (isSuccess) {
      success(
        context: context,
        title: successTitle ?? 'Success',
        message: successMessage ?? 'Operation completed successfully',
      );
    } else {
      error(
        context: context,
        title: errorTitle ?? 'Error',
        message: errorMessage ?? 'Something went wrong. Please try again.',
      );
    }
  }

  /// Dismiss current snackbar
  static void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Show error snackbar without context (uses scaffoldMessengerKey)
  static void showError(String message, {String title = 'Error'}) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    );
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show success snackbar without context (uses scaffoldMessengerKey)
  static void showSuccess(String message, {String title = 'Success'}) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.success,
      ),
    );
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show warning snackbar without context (uses scaffoldMessengerKey)
  static void showWarning(String message, {String title = 'Warning'}) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.warning,
      ),
    );
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

// Extension for easier access
extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String title, String message) {
    AppSnackBar.success(context: this, title: title, message: message);
  }

  void showErrorSnackbar(String title, String message) {
    AppSnackBar.error(context: this, title: title, message: message);
  }

  void showWarningSnackbar(String title, String message) {
    AppSnackBar.warning(context: this, title: title, message: message);
  }

  void showInfoSnackbar(String title, String message) {
    AppSnackBar.info(context: this, title: title, message: message);
  }

  void dismissSnackbar() {
    AppSnackBar.dismiss(this);
  }
}
