import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/screens/home_screen.dart';
import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const DolphinLivinDemo());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'sukha',
          builder: (_, __) => const SukhaScreen(),
        ),
      ],
    ),
  ],
);

class DolphinLivinDemo extends StatelessWidget {
  const DolphinLivinDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Adjust based on your design
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            ScreenUtil
                .ensureScreenSize(); // Optional, ensures the screen size is ready
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
        );
      },
    );
  }
}
