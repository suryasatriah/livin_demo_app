import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:dolphin_livin_demo/services/dolphin_deeplink_redirect.dart';
import 'package:dolphin_livin_demo/utils/utils.dart';
import 'package:dolphin_livin_demo/widgets/explorer/explorer_provider.dart';
import 'package:dolphin_livin_demo/widgets/explorer/widgets/explorer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class ExplorerAnswerGenerator extends StatefulWidget {
  final String question;

  const ExplorerAnswerGenerator({super.key, required this.question});

  @override
  State<ExplorerAnswerGenerator> createState() =>
      _ExplorerAnswerGeneratorState();
}

class _ExplorerAnswerGeneratorState extends State<ExplorerAnswerGenerator>
    with DolphinDeepLinkNavigator {
  late ExplorerProvider explorerProvider;
  late Stream<String> _stream;

  @override
  void initState() {
    super.initState();
    explorerProvider = Provider.of<ExplorerProvider>(context, listen: false);
    _stream = DolphinApi.instance.fetchStream(widget.question);
       
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        Widget displayText;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            displayText = const ExplorerLoading();
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              displayText = const Text('Error');
            } else {
              displayText = generateAnswerWidget(snapshot.data);
            }
            break;
          default:
            displayText = const Text('Disconnected');
        }

        return displayText;
      },
    );
  }

  Widget generateAnswerWidget(String? data) {
    var text = processIncomingData(data);

    if (text != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet(
                    p: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        ))),
            // Text(
            //   text,
            //   style: Theme.of(context).textTheme.labelLarge?.copyWith(
            //         fontWeight: FontWeight.w400,
            //       ),
            // ),
            explorerProvider.button != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical:
                                8.0), // Changed to a fixed value; ensure 8.r if `flutter_screenutil` is initialized
                        child: Divider(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          explorerProvider.button?.label ??
                              'More', // Null-safe operator
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        trailing: IconButton(
                          onPressed: () => navigateDeeplink(
                            context,
                            url: explorerProvider.button?.link ??
                                '', // Null-safe operator
                          ),
                          icon: const Icon(
                            Icons.arrow_outward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    } else {
      return const ExplorerLoading();
    }
  }

  String? processIncomingData(String? data) {
    if (data == null) return "Answer not available";

    if (data.contains("{")) {
      return Provider.of<ExplorerProvider>(context, listen: false)
          .populateAnswerJson(data);
    } else {
      return Utils.decodeUtf8(data);
    }
  }
}
