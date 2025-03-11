import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:logger/logger.dart';

class LoggerService extends Logger {
  static final LoggerService instance = LoggerService._privateConstructor();

  LoggerService._privateConstructor();

  @override
  void e(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    DateTime? time,
    bool sendLogEvent = false,
  }) {

    super.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: time ?? DateTime.now(),
    );

    if (sendLogEvent) DolphinApi.instance.sendLogEvent(message);
  }

   @override
  void i(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    DateTime? time,
    bool sendLogEvent = false,
  }) {

    super.i(
      message,
      error: error,
      stackTrace: stackTrace,
      time: time ?? DateTime.now(),
    );

    if (sendLogEvent) DolphinApi.instance.sendLogEvent(message);
  }
}
