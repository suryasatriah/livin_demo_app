import 'package:dolphin_livin_demo/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DolphinButton {
  static OutlinedButton outlinedButton1(BuildContext context,
      {required String label, void Function()? onPressed}) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(kButtonColor).withOpacity(0.5);
          }
          return const Color(kButtonColor);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(kButtonColor).withOpacity(0.5);
          }
          return const Color(kButtonColor);
        }),
        side: WidgetStateProperty.all<BorderSide>(BorderSide.none),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.r),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
