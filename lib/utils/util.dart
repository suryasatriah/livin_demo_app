import 'dart:convert';

import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:intl/intl.dart';

class Util {
  static String decodeUtf8(String input) {
    try {
      return utf8.decode(input.codeUnits);
    } catch (e, stack) {
      DolphinLogger.instance.e(e, stackTrace: stack);
    }

    return input;
  }

  static String formatAccountNumber(int accountNumber) {
    return NumberFormat("#,##0", "en_US")
        .format(accountNumber)
        .replaceAll(",", " ");
  }

  static String formatCurrency(int amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }
}
