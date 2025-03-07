import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dolphin_livin_demo/core/core_notifier.dart';
import 'package:dolphin_livin_demo/core/permission_handler.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_audio_converter.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_status.dart';
import 'package:dolphin_livin_demo/model/predict_payload.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:dolphin_livin_demo/services/generative_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceBotProvider extends ChangeNotifier with VoiceBotAudioConverter {
  final DolphinLogger _log = DolphinLogger.instance;
  final int _speechListenDuration = 30;
  final String _speechLocaleId = "id_ID";

  VoiceBotStatus voiceBotStatus = VoiceBotStatus.idling;
  bool speechEnabled = false;
  String speechText = "";
  String sessionId = "";
  String ticketNumber = "";
  SpeechToText speechToText = SpeechToText();
  GenerativeService generativeService = GenerativeService();

  CoreNotifier? coreNotifier;

  VoiceBotProvider({this.coreNotifier});

  /// Initialize speech recognition
  /// Permission for microphone is needed to use speech
  /// recognition plugin
  void initSpeech() async {
    PermissionHandler.listenForPermission(Permission.microphone);
    speechEnabled = await speechToText.initialize();
    _log.d("Speech enabled : $speechEnabled");
    sessionId = generateRandomString();
    ticketNumber = generateRandomString();
    notifyListeners();
  }

  /// Start speech recognition session
  void startListen() async {
    speechText = "";
    await speechToText.listen(
      onResult: _onResult,
      listenFor: Duration(seconds: _speechListenDuration),
      localeId: _speechLocaleId,
    );
    _log.d("start listening speech");
    changeVoiceBotStatus(VoiceBotStatus.listening);
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onResult(SpeechRecognitionResult result) {
    speechText = result.recognizedWords;
  }

  void processSpeechText() {
    if (speechText.isNotEmpty) {
      // TO DO process speech text
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListen() async {
    await speechToText.stop();
    _log.d("stop listening speech");
    _log.i("recognized speech: $speechText");
    if (speechText.isNotEmpty) {
      try {
        processMulawStream(submitSpeech());
      } catch (e) {
        _log.e(e);
        onFail();
      }
    } else {
      onFail();
    }
  }

  void cancelListen() async {
    await speechToText.stop();
    _log.d("cancel listening speech");
    speechText = "";
    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  /// Callback when failed retrieve speech
  /// This method called when speechText is empty
  void onFail() async {
    changeVoiceBotStatus(VoiceBotStatus.fail);
    await Future.delayed(const Duration(seconds: 3));
    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  Stream<Uint8List> submitSpeech() {
    var data = createPredictPayload(speechText);
    if (data != null) {
      return generativeService.fetchPredictAudio(data);
    } else {
      throw Exception("data is not ready");
    }
  }

  Future<void> processMulawStream(Stream<Uint8List> mulawStream) async {
    changeVoiceBotStatus(VoiceBotStatus.generating);
    final List<Uint8List> audioChunks = [];

    try {
      // Listen to the stream and collect data
      await for (var chunk in mulawStream) {
        audioChunks.add(chunk);
      }
    } catch (e) {
      _log.e("Error processing Mu-law stream: $e");
      onFail();
      return;
    }

    // Convert the collected data into a Mu-law file
    final tempFile = await _createTempMuLawFile(audioChunks);
    if (tempFile != null) {
      // Convert the Mu-law file to WAV
      String? wavPath = await convertMuLawToWav(tempFile.path);
      playAudio(wavPath);
    }
  }

  // Helper method to create a temporary Mu-law file from the stream data
  Future<File?> _createTempMuLawFile(List<Uint8List> audioChunks) async {
    final dir = await getTemporaryDirectory();
    final tempFile = File('${dir.path}/voice_bot_audio.ulaw');

    // Write the collected chunks to the temporary Mu-law file
    await tempFile.writeAsBytes(audioChunks.expand((x) => x).toList());

    // Return the created Mu-law file
    return tempFile.existsSync() ? tempFile : null;
  }

  Future<void> playAudio(String? wavPath) async {
    if (wavPath != null) {
      changeVoiceBotStatus(VoiceBotStatus.speaking);
      var audioPlayer = AudioPlayer();
      try {
        await audioPlayer.play(DeviceFileSource(wavPath));
        // Wait for completion
        await _waitForAudioCompletion(audioPlayer);
      } catch (e) {
        _log.e(e);
      }
      audioPlayer.dispose();
      onFinish();
    }

    changeVoiceBotStatus(VoiceBotStatus.idling);
  }

  Future<void> onFinish() async {
    try {
      final cacheDir = await getTemporaryDirectory();

      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
        print("Cache cleared successfully.");
      } else {
        print("No cache directory found.");
      }
    } catch (e) {
      print("Error clearing cache: $e");
    }
  }

  Future<void> _waitForAudioCompletion(AudioPlayer audioPlayer) async {
    final completer = Completer<void>();
    void onComplete() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    audioPlayer.onPlayerComplete.listen((_) => onComplete());
    return completer.future;
  }

  /// Change voice bot status using VoiceBotStatus enum
  void changeVoiceBotStatus(VoiceBotStatus voiceBotStatus) {
    if (this.voiceBotStatus == voiceBotStatus) return;
    this.voiceBotStatus = voiceBotStatus;
    notifyListeners();
  }

  Map<String, dynamic>? createPredictPayload(String question) {
    if (coreNotifier?.bot != null) {
      var bot = coreNotifier!.bot;
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
          dolphinLicense: "mandiri",
          ticketNumber: ticketNumber,
          channelId: "EMULATOR",
          channelType: "EMULATOR");
      var payloadJson = payload.toJson();

      return payloadJson;
    }

    return null;
  }
}
