import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_audio_converter.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_provider.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_status.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VoiceBotView extends StatefulWidget {
  const VoiceBotView({super.key});

  @override
  State<VoiceBotView> createState() => _VoiceBotViewState();
}

class _VoiceBotViewState extends State<VoiceBotView>
    with VoiceBotAudioConverter {
  late VoiceBotProvider _voiceBotProvider;

  @override
  void initState() {
    super.initState();
    _voiceBotProvider = Provider.of<VoiceBotProvider>(context, listen: false);
    _voiceBotProvider.initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    String getButtonText(VoiceBotStatus voiceBotStatus) {
      return switch (voiceBotStatus) {
        VoiceBotStatus.generating => "Generating Answer...",
        VoiceBotStatus.idling => "Tap to Speak",
        VoiceBotStatus.listening => "Listening...",
        VoiceBotStatus.speaking => "Speaking...",
        VoiceBotStatus.fail => "Sorry, we didn't catch that one.."
      };
    }

    return Scaffold(
      appBar: DolphinAppBar.appBar1(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "3Dolphins Generative",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "3Dolphins Generative",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              )
            ],
          ),
          Consumer<VoiceBotProvider>(
            builder: (context, provider, _) => Column(
              children: [
                Text(
                  getButtonText(provider.voiceBotStatus),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: switch (provider.voiceBotStatus) {
                    VoiceBotStatus.idling => provider.startListen,
                    VoiceBotStatus.listening => provider.stopListen,
                    _ => null,
                  },
                  child: Container(
                    height: 200.r,
                    width: 200.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: Colors.yellow,
                    ),
                    child: const Center(
                      child: Icon(Icons.mic),
                    ),
                  ),
                ),
                provider.voiceBotStatus != VoiceBotStatus.listening
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: provider.cancelListen,
                        icon: const Icon(Icons.cancel))
              ],
            ),
          )
        ],
      ),
    );
  }
}
