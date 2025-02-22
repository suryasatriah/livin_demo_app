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

  var debugText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris finibus lacinia pharetra. Quisque rhoncus felis ac sem pharetra euismod. Praesent malesuada, felis et pulvinar pharetra, lacus augue fermentum augue, sed gravida metus est at libero. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque auctor libero sem, eu iaculis ligula efficitur sit amet. Praesent efficitur lectus in est fermentum eleifend. Sed et odio quis arcu lacinia iaculis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam sed ipsum enim. Integer varius libero a felis consectetur, et vehicula nisi varius. Maecenas eget risus nec diam commodo iaculis. Morbi sit amet commodo tellus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nulla massa purus, venenatis at orci at, semper sodales neque. Sed eget nulla eget tortor elementum consectetur. Fusce vitae lacinia lorem, quis vulputate ante. Integer volutpat sollicitudin interdum. Nullam auctor facilisis commodo. Praesent pharetra interdum quam, vitae efficitur sem euismod vitae. Fusce egestas aliquet viverra. Cras magna nunc, efficitur vel hendrerit nec, sagittis sit amet mi. Vestibulum quis nisi a risus consequat hendrerit. Cras orci diam, cursus nec cursus vitae, tempor quis ante. Aenean non dignissim erat. Nulla varius neque at neque auctor cursus at vitae erat. Integer tincidunt fermentum dignissim. Duis sodales libero in sem auctor commodo. Ut eget elit a neque pretium vestibulum.";

  ///
  /// Build method
  ///
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
              displayText = Text('System currently under maintenance.',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ));
            } else {
              displayText = generateAnswerWidget(snapshot.data);
              // displayText = generateAnswerWidget(debugText);
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
    var text = processIncomingData(data?.replaceAll('\\n', '\n'));

    if (text != null) {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Make the Markdown content scrollable
                SingleChildScrollView(
                  child: MarkdownBody(
                    data: text,
                    styleSheet: MarkdownStyleSheet(
                      p: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                      a: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                      listBullet:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                    ),
                  ),
                ),
                if (explorerProvider.button != null)
                  Column(
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
                          onPressed: () {
                            Navigator.pop(context);
                            navigateDeeplink(
                              context,
                              url: explorerProvider.button?.link ?? '',
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_outward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
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
