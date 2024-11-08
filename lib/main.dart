import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/screens/home_screen.dart';
import 'package:dolphin_livin_demo/screens/pln/pln_pra_screen.dart';
import 'package:dolphin_livin_demo/screens/sukha_screen.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const DolphinLivinDemo());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
     // builder: (_, __) => const PlnPraScreen(),
      routes: [
        GoRoute(
          path: 'sukha',
          builder: (_, __) => const SukhaScreen(),
        ),
        GoRoute(
          path: 'transfer',
          builder: (context, state) => TransferScreen(
            transferAmount: state.uri.queryParameters['amt'] ?? "0",
            transferDestination:
                state.uri.queryParameters['dest'] ?? "10024520240810",
            destinationName:
                state.uri.queryParameters['name'] ?? "Andriansyah Hakim",
          ),
        ),
        GoRoute(
          path: 'plnpra',
          builder: (context, state) => PlnPraScreen(
            destination: state.uri.queryParameters['dest'],
          ),
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
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
                .copyWith(
              headlineSmall: kHeadlineSmallTextStyle,
              bodyLarge: kBodyLargeTextStyle,
              bodyMedium: kBodyMediumTextStyle,
              labelMedium: kLabelMediumTextStyle,
              labelLarge: kLabelLargeTextStyle,
              titleMedium: kTitleMediumTextStyle,
              titleLarge: kTitleLargeTextStyle,
            ),
          ),
        );
      },
    );
  }
}
