import 'dart:async';
import 'dart:typed_data';

import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';

class PcmSoundSvc {
  final LoggerService _loggerService = LoggerService.instance;

  StreamController<List<int>> pcmStreamController =
      StreamController<List<int>>();

  void onFeed(int remainingFrames) async {
    try {
      pcmStreamController.stream.listen((chunk) async {
        if (chunk.isNotEmpty) {
          await FlutterPcmSound.feed(PcmArrayInt16.fromList(chunk));
        }
      }, onError: (e) {
        _loggerService.e("error feeding pcm data: $e");
      });
    } catch (e) {
      _loggerService.e("error feeding pcm data: $e");
    }
  }

  Future<void> startPcmSound() async {
    pcmStreamController = StreamController<List<int>>.broadcast(); // Recreate the stream
    await FlutterPcmSound.setup(sampleRate: 16000, channelCount: 1);
    await FlutterPcmSound.setFeedThreshold(8000);
    FlutterPcmSound.setFeedCallback(onFeed);
    FlutterPcmSound.setLogLevel(LogLevel.none);
    FlutterPcmSound.start(); // This triggers `onFeed(0)`
  }

  void pushPcmData(List<int> pcmChunk) {
    if (!pcmStreamController.isClosed) {
      pcmStreamController.add(convertToInt16LE(Uint8List.fromList(pcmChunk)));
    }
  }

  void closePcmSound() {
    pcmStreamController.close();
    FlutterPcmSound.release();
  }

  List<int> convertToInt16LE(Uint8List byteData) {
    List<int> int16Data = [];
    for (int i = 0; i < byteData.length; i += 2) {
      int sample = byteData[i] | (byteData[i + 1] << 8); // Little Endian
      if (sample > 32767) sample -= 65536; // Convert to signed int16
      int16Data.add(sample);
    }
    return int16Data;
  }
}
