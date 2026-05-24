import 'package:better_help/utils/app_log/error_log.dart';
import 'package:flutter/foundation.dart';

void appLog(dynamic message) {
  try {
    if (kDebugMode) {
      print("""
✅✅✅ $message ✅✅✅
""");
    }
  } catch (e) {
    errorLog("app log", e);
  }
}
