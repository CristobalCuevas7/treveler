import 'package:flutter/foundation.dart';

class Log {
  static void show(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
