import 'dart:io';

import 'package:dolphin_livin_demo/screens/pln/pln_pra_screen.dart';
import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_amt_view.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_view.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

mixin DolphinDeepLinkNavigator {
  static const String kEndpointPlnPra = "/plnpra";
  static final DolphinLogger _dolphinLogger = DolphinLogger.instance;

  Future<void> navigateDeeplink(BuildContext context,
      {required String url}) async {
    try {
      final uri = Uri.parse(url);

      if ((Platform.isIOS || Platform.isAndroid) && context.mounted) {
        _handleIOSDeeplink(context, uri);
      } else {
        await _launchExternalDeeplink(uri);
      }
    } catch (e) {
      throw Exception("Failed to navigate to URL: ${e.toString()}");
    }
  }

  void _handleIOSDeeplink(BuildContext context, Uri uri) {
    if (uri.path.contains(kEndpointPlnPra)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlnPraScreen(
            amount: uri.queryParameters['amt'],
            destination: uri.queryParameters['dest'],
          ),
        ),
      );
    } else if (uri.path.contains('sukha')) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SukhaScreen()));
    } else if (uri.path.contains("transfer")) {
      if (uri.queryParameters['name'] != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransferView(
                      amount: uri.queryParameters['amt'] ?? "0",
                      destination: uri.queryParameters['dest'],
                    ))).then((_) {});
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransferAmtView(
                      destinationName:
                          uri.queryParameters['name'] ?? "10024520240810",
                      amount: uri.queryParameters['amt'] ?? "0",
                      destination:
                          uri.queryParameters['dest'] ?? "Andriansyah Hakim",
                    ))).then((_) {});
      }
    }
  }

  Future<void> _launchExternalDeeplink(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception("Can't launch url");
      }
    } catch (e, stack) {
      _dolphinLogger.e("Can't launch url : $e", stackTrace: stack);
    }
  }
}
