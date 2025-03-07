import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/core/core_notifier.dart';
import 'package:dolphin_livin_demo/features/voice_bot/voice_bot_view.dart';
import 'package:dolphin_livin_demo/gen/assets.gen.dart';
import 'package:dolphin_livin_demo/screens/web_view_screen.dart';
import 'package:dolphin_livin_demo/widgets/explorer/explorer_view.dart';
import 'package:dolphin_livin_demo/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CoreNotifier>(context, listen: false).init();
  }

  void showFullScreenDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return const ExplorerView();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset("assets/images/home/img_livin_header.png"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.r, 48.r, 8.r, 0.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/home/ic_home_livin.png",
                                height: 32.r,
                              ),
                              Row(
                                children: [
                                  SvgButton(
                                    asset: Assets.icons.icMicrophone.svg(
                                      height: 24.r,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const VoiceBotView())),
                                  ),
                                  ImageButton(
                                    asset:
                                        "assets/images/home/ic_home_search.png",
                                    onTap: () => showFullScreenDialog(context),
                                  ),
                                  ImageButton(
                                      asset:
                                          "assets/images/home/ic_home_livechat.png",
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WebViewScreen(
                                                      url:
                                                          kLiveChatEndpoint)))),
                                  const ImageButton(
                                      asset:
                                          "assets/images/home/ic_home_setting.png"),
                                  const ImageButton(
                                      asset:
                                          "assets/images/home/ic_home_gear.png"),
                                  const ImageButton(
                                      asset:
                                          "assets/images/home/ic_home_quit.png"),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Image.asset("assets/images/home/img_home_middle.jpg"),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/images/home/img_livin_bottom.png"),
            ],
          )
        ],
      ),
    );
  }
}
