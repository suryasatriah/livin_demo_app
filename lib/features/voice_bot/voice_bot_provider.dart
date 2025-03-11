import 'dart:async';

import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/core/core_notifier.dart';
import 'package:dolphin_livin_demo/core/permission_handler.dart';
import 'package:dolphin_livin_demo/features/voice_bot/pcm_sound_svc.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_status.dart';
import 'package:dolphin_livin_demo/model/predict_payload.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:dolphin_livin_demo/services/generative_service.dart';
import 'package:dolphin_livin_demo/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_event.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';

class VoiceBotProvider extends ChangeNotifier {
  final GenerativeService _generativeService = GenerativeService();
  final LoggerService _loggerService = LoggerService.instance;
  final int _speechListenDuration = 20;
  final String _speechLocaleId = "id_ID";

  VoiceBotStatus voiceBotStatus = VoiceBotStatus.idling;
  PcmSoundSvc pcmSoundSvc = PcmSoundSvc();
  StreamSubscription? audioStreamSubscription;
  String speechText = "";
  String sessionId = "";
  String ticketNumber = "";
  int printCount = 0;

  late CoreProvider coreProvider;
  late SpeechToTextProvider speechToTextProvider;

  void initSession() async {
    voiceBotStatus = VoiceBotStatus.idling;
    sessionId = Utility.generateRandomString();
    ticketNumber = Utility.generateRandomString();

    if (!speechToTextProvider.isAvailable) {
      speechToTextProvider.initialize();
    }
  }

  void startListen() {
    PermissionHandler.listenForPermissionMicrophone();
    speechToTextProvider.listen(
      listenFor: Duration(seconds: _speechListenDuration),
      localeId: _speechLocaleId,
    );
    _loggerService.d("start listening speech");
    changeVoiceBotStatus(VoiceBotStatus.listening);
    speechToTextProvider.stream.listen(
      (event) {
        switch (event.eventType) {
          case SpeechRecognitionEventType.doneEvent:
            speechText = speechToTextProvider.lastResult?.recognizedWords ?? "";
            if (speechText.isNotEmpty) _onSubmit();
          default:
            break;
        }
      },
    );
    _loggerService.d("stop listening speech");
  }

  void stopListen() {
    speechToTextProvider.stop();
    _loggerService.d("stop listening speech");
    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  void cancelListen() async {
    speechToTextProvider.cancel();
    speechText = "";
    _loggerService.d("cancel listening speech");
    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  void _onFail() async {
    changeVoiceBotStatus(VoiceBotStatus.fail);
    await Future.delayed(const Duration(seconds: 3));
    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  void _onSubmit() {
    if (VoiceBotStatus.generating == voiceBotStatus) return;
    changeVoiceBotStatus(VoiceBotStatus.generating);
    try {
      var audioStream = _getAudioStream();
      processAudioStream(audioStream);
    } catch (e) {
      _loggerService.e("error submit and get answer stream: $e");
      _onFail();
    }
  }

  Stream<List<int>> _getAudioStream() {
    var data = createPredictPayload(speechText);
    if (data != null) {
      return _generativeService.fetchPredictAudioMp3(data);
    } else {
      throw Exception("data is not ready");
    }
  }

  Future<void> processAudioStream(Stream<List<int>> audioStream) async {
    _loggerService.d("process audio speech");
    changeVoiceBotStatus(VoiceBotStatus.generating);

    try {
      await pcmSoundSvc.startPcmSound();
      audioStreamSubscription = audioStream.listen(
        (data) => pcmSoundSvc.pushPcmData(data),
        onError: _onError,
        onDone: _onDoneStream,
      );
    } catch (e, stackTrace) {
      _loggerService.e("error process audio stream: $e",
          stackTrace: stackTrace);
      _onFail();
    }
  }

  void _onError(Object e, StackTrace stackTrace) {
    _loggerService.e("error in stream listening: $e");
    _onFail();
  }

  void _onDoneStream() {
    _loggerService.d("done delivering audio");
    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  Future<void> onSpeak() async {
    if (speechToTextProvider.isListening) {
      speechToTextProvider.stop();
    }
  }

  /// Change voice bot status using VoiceBotStatus enum
  void changeVoiceBotStatus(VoiceBotStatus voiceBotStatus) {
    if (this.voiceBotStatus == voiceBotStatus) return;
    this.voiceBotStatus = voiceBotStatus;
    if (kDebugMode) print("changed voice bot status: $voiceBotStatus");
    notifyListeners();
  }

  Map<String, dynamic>? createPredictPayload(String question) {
    var bot = coreProvider.bot;
    var payload = PredictPayload(
        botThinkConfig: BotThinkConfig(
            confident: bot.confident,
            maxDocumentLimit: bot.maxDocumentLimit,
            documentTokenLength: bot.documentTokenLength,
            documentRelevancy: bot.documentRelevancy,
            processFlowRelevancy: bot.documentRelevancy,
            reRank: bot.reRank,
            maxDocumentRetryLimit: bot.maxDocumentRetryLimit,
            retainHistoryFallback: bot.retainHistoryFallback),
        owner: bot.owner,
        botId: bot.id,
        botName: bot.botName,
        persona: bot.botPersona.first,
        sessionId: sessionId,
        language: "indonesia",
        question: [question],
        dolphinLicense: kLicense,
        ticketNumber: ticketNumber,
        channelId: "audio_emulator",
        channelType: "audio_emulator");
    var payloadJson = payload.toJson();

    return payloadJson;
  }

  void closeSession() {
    pcmSoundSvc.closePcmSound();
    audioStreamSubscription?.cancel();
    audioStreamSubscription = null;
  }
}
