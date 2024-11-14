import 'dart:io';

import 'package:dolphin_livin_demo/screens/pln/pln_pra_screen.dart';
import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

mixin DolphinDeepLinkNavigator {
  static const String kEndpointPlnPra = "/plnpra";

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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransferScreen(
                    destinationName:
                        uri.queryParameters['name'] ?? "10024520240810",
                    transferAmount: uri.queryParameters['amt'] ?? "0",
                    transferDestination:
                        uri.queryParameters['dest'] ?? "Andriansyah Hakim",
                  ))).then((_) {});
    }
  }

  Future<void> _launchExternalDeeplink(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Unable to launch URL.");
    }
  }
}
