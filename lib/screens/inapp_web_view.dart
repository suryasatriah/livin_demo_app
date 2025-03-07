import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_amt_view.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_view.dart';
import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:dolphin_livin_demo/widgets/webView/web_view_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String url;

  const InAppWebViewScreen({super.key, required this.url});

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  bool isNavigating = false; // Fix for handling navigation state

  final InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    allowsAirPlayForMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (webViewController != null) {
                if (Platform.isAndroid) {
                  await webViewController!.reload();
                } else if (Platform.isIOS) {
                  var currentUrl = await webViewController!.getUrl();
                  if (currentUrl != null) {
                    await webViewController!
                        .loadUrl(urlRequest: URLRequest(url: currentUrl));
                  }
                }
              }
            },
          );
  }

  void onConsoleMessage(ConsoleMessage consoleMessage) {
    var logEvent = {
      "type": "JavaScriptConsoleMessage",
      "level": consoleMessage.messageLevel,
      "message": consoleMessage.message,
    };

    if (consoleMessage.messageLevel != ConsoleMessageLevel.ERROR) {
      DolphinLogger.instance.d("Console Message: ${logEvent.toString()}");
    } else {
      DolphinLogger.instance.e("Console Message: ${logEvent.toString()}");
      DolphinApi.instance.sendLogEvent(logEvent.toString());
    }
  }

  Future<NavigationActionPolicy> handleNavigationRequest(
      BuildContext context, NavigationAction request) async {
    if (request.request.url.toString().startsWith('https://www.youtube.com/')) {
      return NavigationActionPolicy.CANCEL;
    }

    if (request.request.url.toString().contains('sukha') || request.request.url.toString().contains('transfer')) {
      if ((Platform.isIOS || Platform.isAndroid) && mounted) {
        if (!isNavigating) {
          isNavigating = true;
          if (request.request.url.toString().contains('sukha')) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SukhaScreen())).then((_) {
              isNavigating = false;
            });
          } else if (request.request.url.toString().contains('transfer') &&
              Uri.parse(request.request.url.toString()).queryParameters['name'] != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransferAmtView(
                          destinationName:
                              Uri.parse(request.request.url.toString()).queryParameters['name'] ?? "Surya",
                          amount: Uri.parse(request.request.url.toString()).queryParameters['amt'] ?? "0",
                          destination:
                              Uri.parse(request.request.url.toString()).queryParameters['dest'] ?? "1234321234",
                        ))).then((_) {
              isNavigating = false;
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransferView(
                          amount: Uri.parse(request.request.url.toString()).queryParameters['amt'] ?? "0",
                        ))).then((_) {
              isNavigating = false;
            });
          }
        }
        return NavigationActionPolicy.CANCEL;
      } else if (await canLaunchUrl(Uri.parse(request.request.url.toString()))) {
        await launchUrl(Uri.parse(request.request.url.toString()),
            mode: LaunchMode.externalApplication);
        return NavigationActionPolicy.CANCEL;
      } else {
        return NavigationActionPolicy.CANCEL;
      }
    }

    return NavigationActionPolicy.ALLOW;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(57),
        child: WebViewAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: settings,
              pullToRefreshController: pullToRefreshController,
            
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                Uri uri = navigationAction.request.url!;
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                if (!context.mounted) return NavigationActionPolicy.CANCEL;

                return handleNavigationRequest(context, navigationAction);
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                onConsoleMessage(consoleMessage);
              },
            ),
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      ),
    );
  }
}
