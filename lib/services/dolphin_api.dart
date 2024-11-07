import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/services/dolphin_dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class DolphinApi {
  static const String kEndpointPredictUi =
      "/dolphin/apiv1/generative/predict/ui";

  static final DolphinLogger dolphinLogger = DolphinLogger.instance;
  static final DolphinDio dolphinDio = DolphinDio.instance;

  static final DolphinApi instance = DolphinApi._privateConstructor();

  DolphinApi._privateConstructor();

  Future<void> getSingleChatAnswer(String question) async {
    try {
      var url = kGenerativeUrl + kEndpointPredictUi;
      var questionPayload = {
        "question": [question]
      };
      var generatedPayload = {
        "sessionId": "string",
        "ticketNumber": "string",
      };
      var payload = kBasicPredictPayload
        ..addAll(questionPayload)
        ..addAll(generatedPayload);

      var response = await dolphinDio.post(url, data: payload);
      

    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
  }
}
