import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class DolphinDioInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final int retryIntervalMs;

  final DolphinLogger dolphinLogger = DolphinLogger.instance;

  DolphinDioInterceptor({
    required this.dio,
    this.maxRetries = 1,
    this.retryIntervalMs = 1000,
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) &&
        err.requestOptions.extra['retries'] < maxRetries) {
      err.requestOptions.extra['retries'] =
          (err.requestOptions.extra['retries'] ?? 0) + 1;
      dolphinLogger.w(
          "Connection timeout, retrying(${err.requestOptions.extra['retries']})");

      await Future.delayed(Duration(milliseconds: retryIntervalMs));

      try {
        final response = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  bool _shouldRetry(DioException dioException) {
    return dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.receiveTimeout;
  }
}
