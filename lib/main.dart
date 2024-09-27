import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const DolphinLivinDemo());
}

class DolphinLivinDemo extends StatelessWidget {
  const DolphinLivinDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Adjust based on your design
      builder: (context, child) {
        return MaterialApp(
          builder: (context, widget) {
            ScreenUtil.ensureScreenSize(); // Optional, ensures the screen size is ready
            return widget!;
          },
          theme: ThemeData().copyWith(
            textTheme: const TextTheme().copyWith(
              headlineSmall: kHeadlineSmallTextStyle,
              bodyLarge: kBodyLargeTextStyle,
              bodyMedium: kBodyMediumTextStyle,
              labelMedium: kLabelMediumTextStyle,
              titleMedium: kTitleMediumTextStyle,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
