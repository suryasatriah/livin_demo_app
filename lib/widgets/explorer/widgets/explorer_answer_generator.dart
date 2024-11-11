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
  void didUpdateWidget(covariant ExplorerAnswerGenerator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the question has changed; if so, recreate the stream
    if (oldWidget.question != widget.question) {
      _stream = DolphinApi.instance.fetchStream(widget.question);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
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
                    ),
              ),
            ),
            explorerProvider.button != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          explorerProvider.button?.label ?? 'More',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        trailing: IconButton(
                          onPressed: () => navigateDeeplink(
                            context,
                            url: explorerProvider.button?.link ?? '',
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
      return explorerProvider.populateAnswerJson(data);
    } else {
      return Utils.decodeUtf8(data);
    }
  }
}
