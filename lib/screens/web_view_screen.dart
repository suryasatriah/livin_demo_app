import 'dart:io';

import 'package:dolphin_livin_demo/core/permission_handler.dart';
import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_amt_view.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_view.dart';
import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:dolphin_livin_demo/widgets/webView/web_view_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController webViewController;
  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    super.initState();
    PermissionHandler().listenForPermissions();
    initController();
  }

  initController() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webViewController = WebViewController.fromPlatformCreationParams(params);

    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setOnConsoleMessage(
          (consoleMessage) => onConsoleMessage(consoleMessage))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) =>
              handleNavigationRequest(context, request, mounted),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  onConsoleMessage(JavaScriptConsoleMessage consoleMessage) {
    var logEvent = {
        "type": "JavaScriptConsoleMessage",
        "level": consoleMessage.level,
        "message": consoleMessage.message,
      };
    
   
    if (consoleMessage.level == JavaScriptLogLevel.error) {
      DolphinLogger.instance.e("onConsoleMessage() consoleMessage: ${logEvent.toString()}");
      DolphinApi.instance.sendLogEvent(
        logEvent.toString()
      );
    } else {
       DolphinLogger.instance.d("onConsoleMessage() consoleMessage: ${logEvent.toString()}");
    }
  }

  Future<NavigationDecision> handleNavigationRequest(
      BuildContext context, NavigationRequest request, bool mounted) async {
    if (request.url.startsWith('https://www.youtube.com/')) {
      return NavigationDecision.prevent;
    }

    if (request.url.contains('sukha') || request.url.contains('transfer')) {
      if ((Platform.isIOS || Platform.isAndroid) && mounted) {
        var isNavigating = false;
        if (!isNavigating) {
          isNavigating = true;
          if (request.url.contains('sukha')) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SukhaScreen()));
          } else if (request.url.contains('transfer') &&
              Uri.parse(request.url).queryParameters['name'] != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransferAmtView(
                          destinationName:
                              Uri.parse(request.url).queryParameters['name'] ??
                                  "10024520240810",
                          amount:
                              Uri.parse(request.url).queryParameters['amt'] ??
                                  "0",
                          destination:
                              Uri.parse(request.url).queryParameters['dest'] ??
                                  "Andriansyah Hakim",
                        ))).then((_) {
              isNavigating = false;
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransferView(
                          amount:
                              Uri.parse(request.url).queryParameters['amt'] ??
                                  "0",
                        ))).then((_) {
              isNavigating = false;
            });
          }
        }

        return NavigationDecision.prevent;
      } else if (await canLaunchUrl(Uri.parse(request.url))) {
        await launchUrl(Uri.parse(request.url),
            mode: LaunchMode.externalApplication);

        return NavigationDecision.prevent;
      } else {
        return NavigationDecision.prevent;
      }
    }

    return NavigationDecision.navigate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57.r),
        child: const WebViewAppBar(),
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(0, 4.r, 0, 8.r),
          child: WebViewWidget(controller: webViewController)),
    );
  }
}
