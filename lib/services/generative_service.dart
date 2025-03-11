import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dolphin_livin_demo/services/base_service.dart';
import 'package:dolphin_livin_demo/services/dolphin_dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class GenerativeService extends BaseService {
  final DolphinDio _dio = DolphinDio.instance;
  final LoggerService _loggerService = LoggerService.instance;

  static const String kEndpointPredictAudio = "/predict/voice";

  Stream<Uint8List> fetchPredictAudio(Map<String, dynamic> data) {
    StreamController<Uint8List> controller = StreamController<Uint8List>();

    var url = getGenerativeUrl(kEndpointPredictAudio);

    _loggerService.i({
      "url": url,
      "payload": data,
    });

    _dio
        .post(
      url,
      data: data,
      responseType: ResponseType.stream,
    )
        .then(
      (response) async {
        _loggerService.i(response.headers);

        response.data.stream.listen(
          (data) {
            if (data is List<int>) {
              controller.add(Uint8List.fromList(data)); // Convert to Uint8List
            } else {
              _loggerService.e("Unexpected data type: ${data.runtimeType}");
            }
          },
          onDone: () {
            _loggerService.i("Stream complete");
            controller.close();
          },
          onError: (error) {
            _loggerService.e(error);
            controller.addError(error);
            controller.close();
          },
          cancelOnError: true,
        );
      },
    ).catchError(
      (error) {
        _loggerService.e(error);
        controller.addError(error);
        controller.close();
      },
    ).onError((error, stackTrace) {
      _loggerService.e(error, stackTrace: stackTrace);
      controller.addError(error ?? 'error');
      controller.close();
    });

    return controller.stream;
  }

  Stream<List<int>> fetchPredictAudioMp3(Map<String, dynamic> data) async* {
    final url = getGenerativeUrl(kEndpointPredictAudio);
    _loggerService.i({"url": url, "payload": data});

    try {
      final response = await _dio.post(
        url,
        data: data,
        responseType: ResponseType.stream,
      );

      _loggerService.i("Response Headers: ${response.headers}");

      await for (var chunk in response.data.stream.handleError((error) {
        _loggerService.e("Stream error: $error");
        throw error; // Rethrow error to propagate it to the caller
      })) {
        if (chunk is List<int>) {
          yield chunk;
        } else {
          _loggerService.e("Unexpected data type: ${chunk.runtimeType}");
        }
      }
    } catch (error, stackTrace) {
      _loggerService.e("API request error: $error", stackTrace: stackTrace);
      rethrow; // Rethrow to let the caller handle the error
    }
  }
}
