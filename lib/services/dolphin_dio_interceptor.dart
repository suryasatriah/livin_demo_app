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
      DioException dioException, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(dioException) &&
        dioException.requestOptions.extra['retries'] < maxRetries) {
      dioException.requestOptions.extra['retries'] =
          (dioException.requestOptions.extra['retries'] ?? 0) + 1;
      dolphinLogger.w(
          "Connection timeout, retrying(${dioException.requestOptions.extra['retries']})");

      await Future.delayed(Duration(milliseconds: retryIntervalMs));

      try {
        final response = await dio.request(
          dioException.requestOptions.path,
          options: Options(
            method: dioException.requestOptions.method,
            headers: dioException.requestOptions.headers,
          ),
          data: dioException.requestOptions.data,
          queryParameters: dioException.requestOptions.queryParameters,
        );
        return handler.resolve(response);
      } catch (e) {
        return super.onError(dioException, handler);
      }
    } else {
      super.onError(dioException, handler);
    }
  }

  bool _shouldRetry(DioException dioException) {
    return dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.receiveTimeout;
  }
}
