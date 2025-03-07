import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';

mixin VoiceBotAudioConverter {
  Future<String?> convertMuLawToWav(String inputPath) async {
    final dir = await getTemporaryDirectory();
    final outputPath = '${dir.path}/converted_voice_bot_audio.wav';
    await FFmpegKit.execute('-f mulaw -ar 8000 -i $inputPath $outputPath');
    return File(outputPath).existsSync() ? outputPath : null;
  }

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
}
