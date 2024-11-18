import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

import 'dolphin_dio_interceptor.dart';

class DolphinDio {
  static final DolphinDio instance = DolphinDio._privateConstructor();
  static final dolphinLogger = DolphinLogger.instance;
  static final _baseOptions = BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(minutes: 1),
  );

  DolphinDio._privateConstructor();

  Dio buildDio() {
    return Dio(_baseOptions)
      ..interceptors.add(DolphinDioInterceptor(dio: Dio(_baseOptions)));
  }

  Future<Response> get(String url,
      {String? token,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    if (token != null) _baseOptions.headers["authorization"] = "Bearer $token";

    var dio = buildDio();

    try {
      var response = await dio.get(
        url,
        queryParameters: queryParameters,
        data: data,
      );

      prettyPrintJson(response);
      return response;
    } on DioException catch (e) {
      _handleDioException(e, url: url);
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  Future<Response> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    String? token,
  }) async {
    if (responseType != null) _baseOptions.responseType = responseType;
    if (token != null) _baseOptions.headers["authorization"] = "Bearer $token";

    var dio = buildDio();

    try {
      return await dio.post(
        url,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  Future<Response> put(String url,
      {String? token,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    if (token != null) _baseOptions.headers["authorization"] = "Bearer $token";

    var dio = buildDio();

    try {
      return await dio.put(
        url,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  Future<Response> delete(String url,
      {String? token,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    if (token != null) _baseOptions.headers["authorization"] = "Bearer $token";

    var dio = buildDio();

    try {
      return await dio.delete(
        url,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      dio.close();
    }
  }

  void prettyPrintJson(dynamic input) {
    if (input.data is Map || input.data is List) {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(input.data);
      dolphinLogger.d(prettyJson);
    } else {
      dolphinLogger.d(input.data.toString());
    }
  }

  void _handleDioException(e, {String? url}) {
    if (e.response != null) {
      // The server responded with a non-2xx status code
      _handleServerError(e, url);
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      // Handle connection timeout
      _handleTimeoutError(e);
    } else if (e.type == DioExceptionType.cancel) {
      // Handle request cancellation
      _handleCancelError(e);
    } else {
      // Handle other Dio errors (e.g., bad request)
      _handleOtherDioError(e);
    }
  }

  void _handleServerError(DioException e, String? url) {
    // Log server error details
    dolphinLogger.w(
        'Server Error: ${e.response?.statusCode} - ${e.response?.data} - $url');
  }

  void _handleTimeoutError(DioException e) {
    // Log timeout error details
    dolphinLogger.w('Timeout Error: ${e.message}');
    // Additional handling, e.g., retry logic, inform the user, etc.
  }

  void _handleCancelError(DioException e) {
    // Log cancel error details
    dolphinLogger.w('Request Canceled: ${e.message}');
    // Additional handling if needed
  }

  void _handleOtherDioError(DioException e) {
    // Log other Dio error details
    dolphinLogger.w('Dio Error: ${e.message}');
  }
}
