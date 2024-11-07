import 'package:logger/logger.dart';

class DolphinLogger extends Logger {
  static final DolphinLogger instance = DolphinLogger._privateConstructor();

  DolphinLogger._privateConstructor();

  @override
  void e(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    DateTime? time,
  }) {

    super.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: time ?? DateTime.now(),
    );
  }
}
