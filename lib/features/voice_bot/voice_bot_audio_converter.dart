import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

mixin VoiceBotAudioConverter {
  Future<String?> convertMuLawToWav(String inputPath) async {
    final dir = await getTemporaryDirectory();
    final outputPath = '${dir.path}/converted_voice_bot_audio.wav';
    await FFmpegKit.execute('-f mulaw -ar 8000 -i $inputPath $outputPath');
    return File(outputPath).existsSync() ? outputPath : null;
  }
}
