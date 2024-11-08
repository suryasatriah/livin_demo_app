import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/model/result.dart';
import 'package:dolphin_livin_demo/services/dolphin_dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class DolphinApi {
  static const String kEndpointPredictUi =
      "/dolphin/apiv1/generative/predict/ui";
  static const String kEndpointSuggestion =
      "/dolphin/apiv1/graph/workflow/b74092844998a190470ad5424697947d/WF/node-1731039934911/webhook";

  static final DolphinLogger dolphinLogger = DolphinLogger.instance;
  static final DolphinDio dolphinDio = DolphinDio.instance;

  static final DolphinApi instance = DolphinApi._privateConstructor();

  DolphinApi._privateConstructor();

  String generateRandomString() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format date and time into a string
    String dateTimeString = now.toIso8601String();

    // Generate a random integer to add more randomness
    int randomInt = Random().nextInt(10000);

    // Combine date, time, and random integer
    String combinedString = '$dateTimeString$randomInt';

    // Hash the combined string using SHA256 for a 32-character result
    String hashString = sha256.convert(utf8.encode(combinedString)).toString();

    // Take the first 32 characters to match the example format
    return hashString.substring(0, 32); // Adjust length as needed
  }

  Future<Result?> getResult(String question) async {
    try {
      var url = kGenerativeUrl + kEndpointPredictUi;
      var questionPayload = {
        "question": [question]
      };
      var generatedPayload = {
        "sessionId": generateRandomString(),
        "ticketNumber": generateRandomString(),
      };
      var payload = kBasicPredictPayload
        ..addAll(questionPayload)
        ..addAll(generatedPayload);

      dolphinLogger.i(payload);

      var response = await dolphinDio.post(url, data: payload);
      dolphinLogger.i(response.data);

      return Result.fromJson(
          jsonDecode(response.data['result'].replaceAll("'", "\"")));
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
    return null;
  }

  Future<List<String>?> getSuggestions() async {
    try {
      var url = kNonGenerativeUrl + kEndpointSuggestion;

      var response = await dolphinDio.post(url);
      dolphinLogger.i(response.data);

      var answer = response.data['data']['value']['answer'];

      // Replace single quotes with double quotes to make it valid JSON
      var result = answer.replaceAll("'", "\"");

      // Parse the result JSON
      var resultJson = jsonDecode(result);

      // Extract the 'suggestion' list and convert it to List<String>
      List<String> stringList = List<String>.from(resultJson['suggestion']);

      // Print to verify
      print(stringList);

      return stringList;
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
    return null;
  }
}
