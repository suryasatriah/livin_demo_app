import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dolphin_livin_demo/services/base_service.dart';
import 'package:dolphin_livin_demo/services/dolphin_dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class GenerativeService extends BaseService {
  final DolphinDio _dio = DolphinDio.instance;
  final DolphinLogger _logger = DolphinLogger.instance;

  static const String kEndpointPredictAudio = "/predict/voice";

  Stream<Uint8List> fetchPredictAudio(Map<String, dynamic> data) {
    StreamController<Uint8List> controller = StreamController<Uint8List>();

    
    var url = getGenerativeUrl(kEndpointPredictAudio);

    _logger.i({
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
        _logger.i(response.headers);

        response.data.stream.listen(
          (data) {
            if (data is List<int>) {
              controller.add(Uint8List.fromList(data)); // Convert to Uint8List
            } else {
              _logger.e("Unexpected data type: ${data.runtimeType}");
            }
          },
          onDone: () {
            _logger.i("Stream complete");
            controller.close();
          },
          onError: (error) {
            _logger.e(error);
            controller.addError(error);
            controller.close();
          },
          cancelOnError: true,
        );
      },
    ).catchError(
      (error) {
        _logger.e(error);
        controller.addError(error);
        controller.close();
      },
    ).onError((error, stackTrace) {
      _logger.e(error, stackTrace: stackTrace);
      controller.addError(error ?? 'error');
      controller.close();
    });

    return controller.stream;
  }
}
