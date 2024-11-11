import 'dart:convert';

import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class Utils {
  static String decodeUtf8(String input) {
    try {
      return utf8.decode(input.codeUnits);
    } catch (e, stack) {
      DolphinLogger.instance.e(e, stackTrace: stack);
    }

    return input;
  }
}
