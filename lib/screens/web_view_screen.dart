import 'dart:io';

import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_screen.dart';
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
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }

            if (request.url.contains('sukha') ||
                request.url.contains('transfer')) {
              if (Platform.isIOS && mounted) {
                var isNavigating = false;
                if (!isNavigating) {
                  isNavigating = true;
                  request.url.contains('sukha')
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SukhaScreen()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransferScreen(
                                    destinationName: Uri.parse(request.url)
                                            .queryParameters['name'] ??
                                        "10024520240810",
                                    transferAmount: Uri.parse(request.url)
                                            .queryParameters['amt'] ??
                                        "0",
                                    transferDestination: Uri.parse(request.url)
                                            .queryParameters['dest'] ??
                                        "Andriansyah Hakim",
                                  ))).then((_) {
                          isNavigating = false;
                        });
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
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
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
