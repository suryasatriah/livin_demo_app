import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_audio_converter.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_provider.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_status.dart';
import 'package:dolphin_livin_demo/gen/assets.gen.dart';
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
      appBar: DolphinAppBar.preferredSizeWidget(
          widget: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.r),
                        child: Assets.icons.icMita.image(
                          width: 48.r,
                          height: 48.r,
                        ),
                      ),
                      Text(
                        "Ask Mita",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Consumer<VoiceBotProvider>(
            builder: (context, provider, _) => Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.blue, Colors.white],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      getButtonText(provider.voiceBotStatus),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.r),
                      child: RawMaterialButton(
                        onPressed: switch (provider.voiceBotStatus) {
                          VoiceBotStatus.idling => provider.startListen,
                          VoiceBotStatus.listening => provider.stopListen,
                          _ => null,
                        },
                        fillColor: switch (provider.voiceBotStatus) {
                          VoiceBotStatus.listening => Colors.red,
                          _ => Colors.white,
                        },
                        padding: EdgeInsets.all(48.r),
                        shape: const CircleBorder(),
                        child: Center(
                          child: Assets.icons.icMicrophone.svg(
                            width: 48.r,
                            height: 48.r,
                            colorFilter: ColorFilter.mode(
                                switch (provider.voiceBotStatus) {
                                  VoiceBotStatus.listening => Colors.white,
                                  _ => Colors.blue
                                },
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<VoiceBotProvider>(
            builder: (context, provider, _) => Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  provider.voiceBotStatus != VoiceBotStatus.listening
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: provider.cancelListen,
                          iconSize: 48.r,
                          icon: const Icon(Icons.cancel),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
