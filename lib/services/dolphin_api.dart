import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/model/auth_token.dart';
import 'package:dolphin_livin_demo/model/bot.dart';
import 'package:dolphin_livin_demo/model/result.dart';
import 'package:dolphin_livin_demo/services/base_service.dart';
import 'package:dolphin_livin_demo/services/dolphin_dio.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';

class DolphinApi extends BaseService {
  static const String kEndpointPredictUi = "/predict/ui";
  static const String kEndpointPredictStream = "/predict/stream";

  static const String kEndpointSuggestion =
      "/workflow/b74092844998a190470ad5424697947d/WF/node-1731039934911/webhook";

  static final DolphinLogger dolphinLogger = DolphinLogger.instance;
  static final DolphinDio _httpClient = DolphinDio.instance;

  DolphinApi._privateConstructor();

  static final DolphinApi instance = DolphinApi._privateConstructor();

  static const int kPortNonGenerative = 9443;
  static const int kPortGenerative = 7182;

  static const String kEndpointNonGenerative = "/dolphin/apiv1/graph";
  static const String kEndpointGenerative = "/dolphin/apiv1/generative";
  static const String kEndpontAuth = "/auth";
  static const String kEndpointAuthRefreshToken = "/auth/refreshToken";
  static const String kEndpointBots = "/bots";

  Future<Result?> getResult(String question) async {
    try {
      var url = getGenerativeUrl(kEndpointPredictUi);
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

      var response = await _httpClient.post(url, data: payload);
      dolphinLogger.i(response.data);

      return Result.fromJson(
          jsonDecode(response.data['result'].replaceAll("'", "\"")));
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
    return null;
  }

  Future<List<String>> getSuggestions() async {
    try {
      var url = getNonGenerativeUrl(kEndpointSuggestion);
      var response = await _httpClient.post(url);
      dolphinLogger.i(response.data);

      // Ensure response data is parsed as JSON if it’s a string
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      // Access the required fields after verifying responseData is a Map
      if (responseData is Map &&
          responseData.containsKey('data') &&
          responseData['data']['value'].containsKey('answer')) {
        var answer = responseData['data']['value']['answer'];

        // Replace single quotes with double quotes to make it valid JSON
        var result = answer.replaceAll("'", "\"");

        // Parse the result JSON
        var resultJson = jsonDecode(result);

        // Extract the 'suggestion' list and convert it to List<String>
        List<String> stringList = List<String>.from(resultJson['suggestion']);

        return stringList;
      } else {
        dolphinLogger.e("Unexpected response format");
      }
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
    return [];
  }

  Future<List<String>> getSuggestionsNative() async {
    try {
      Dio dio = Dio();

      var url = getNonGenerativeUrl(kEndpointSuggestion);
      var response = await dio.post(url);
      dolphinLogger.i(response.data);

      // Ensure response data is parsed as JSON if it’s a string
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      // Access the required fields after verifying responseData is a Map
      if (responseData is Map &&
          responseData.containsKey('data') &&
          responseData['data']['value'].containsKey('answer')) {
        var answer = responseData['data']['value']['answer'];

        // Replace single quotes with double quotes to make it valid JSON
        var result = answer.replaceAll("'", "\"");

        // Parse the result JSON
        var resultJson = jsonDecode(result);

        // Extract the 'suggestion' list and convert it to List<String>
        List<String> stringList = List<String>.from(resultJson['suggestion']);

        return stringList;
      } else {
        dolphinLogger.e("Unexpected response format");
      }
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
    return [];
  }

  Future<void> sendLogEvent(String log) async {
    try {
      await _httpClient
          .post("http://mandiri.3dolphins.ai:19000/log", data: {'log': log});
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }
  }

  Stream<String> fetchStream(
    String question, {
    void Function()? onStart,
    void Function(String?)? onComplete,
  }) {
    if (onStart != null) onStart();

    StreamController<String> controller = StreamController<String>();
    StringBuffer paragraph = StringBuffer();

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

    _httpClient
        .post(
      getGenerativeUrl(kEndpointPredictStream),
      data: payload,
      responseType: ResponseType.stream,
    )
        .then(
      (response) async {
        try {
          await for (var data in response.data.stream) {
            var char = String.fromCharCodes(data);
            paragraph.write(char);
            controller.add(paragraph.toString().trim());
          }

          dolphinLogger.i("paragraph: $paragraph");
        } catch (e) {
          dolphinLogger.e(e);
          controller.addError(e);
        } finally {
          controller.close();
          if (onComplete != null) onComplete(paragraph.toString().trim());
        }
      },
    ).catchError(
      (error) {
        dolphinLogger.e(error);
        controller.addError(error);
        controller.close();
      },
    ).onError((error, stackTrace) {
      dolphinLogger.e(error, stackTrace: stackTrace);
      controller.addError(error ?? 'error');
      controller.close();
    });

    return controller.stream;
  }

  /// Fetches the authentication token for a user.
  ///
  /// Sends a POST request with the provided [username] and [password]
  /// to the authentication endpoint. If successful, returns an [AuthToken].
  ///
  /// Returns `null` if an error occurs or the response data is null.
  Future<AuthToken?> fetchAuthToken(
    String username,
    String password,
  ) async {
    try {
      var data = {
        "username": username,
        "password": password,
      };
      var response = await _httpClient.post(
        getNonGenerativeUrl(kEndpontAuth),
        data: data,
      );

      if (response.data != null) {
        return AuthToken.fromJson(response.data);
      } else {
        throw Exception("response data is null");
      }
    } catch (e, stackTrace) {
      dolphinLogger.e(e, stackTrace: stackTrace);
    }

    return null;
  }

  /// Fetches the authentication token for a user.
  ///
  /// Sends a POST request with the provided [token] as authorization header
  /// to the authentication endpoint. If successful, returns an [AuthToken].
  ///
  /// Returns `null` if an error occurs or the response data is null.
  Future<AuthToken?> fetchAuthTokenByToken(String token) async {
    try {
      var response = await _httpClient.post(
        getNonGenerativeUrl(kEndpointAuthRefreshToken),
        token: token,
      );

      if (response.data != null) {
        return AuthToken.fromJson(response.data);
      } else {
        throw Exception("response data is null");
      }
    } catch (e, stackTrace) {
      dolphinLogger.e(e, stackTrace: stackTrace);
    }

    return null;
  }

  Future<Bot?> fetchBot(
      {String? botId,
      required String token,
      int start = 0,
      int count = 10}) async {
    try {
      var queryParameters = {
        if (botId != null) "botId": botId,
        "start": start,
        "count": count,
      };

      var response = await _httpClient.get(getNonGenerativeUrl(kEndpointBots),
          queryParameters: queryParameters, token: token);

      return Bot.fromJson(response.data['data']);
    } catch (e, stackTrace) {
      dolphinLogger.e(e, stackTrace: stackTrace);
    }

    return null;
  }
}
