import 'dart:developer';

import 'package:flutter/foundation.dart';

class LoggerUtils {
  static void logs(String message) {
    if (kDebugMode) {
      log(message);
    }
  }
}
