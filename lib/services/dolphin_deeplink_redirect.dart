import 'dart:io';

import 'package:dolphin_livin_demo/screens/pln/pln_pra_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

mixin DolphinDeepLinkNavigator {
  static const String kEndpointPlnPra = "/plnpra";

  Future<void> navigateDeeplink(BuildContext context,
      {required String url}) async {
    try {
      final uri = Uri.parse(url);

      if (Platform.isIOS && context.mounted) {
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
