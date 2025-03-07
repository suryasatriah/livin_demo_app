import 'package:flutter/material.dart';

class DolphinAppBar {
  static PreferredSizeWidget preferredSizeWidget(
      {required Widget widget, double height = 40.0}) {
    return PreferredSize(preferredSize: Size.fromHeight(height), child: widget);
  }

  static PreferredSizeWidget appBar1({bool automaticallyImplyLeading = true}) {
    return preferredSizeWidget(
      widget: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          backgroundColor: Colors.white.withOpacity(1)),
    );
  }
}
