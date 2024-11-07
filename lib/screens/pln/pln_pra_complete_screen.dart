import 'package:dolphin_livin_demo/screens/home_screen.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlnPraCompleteScreen extends StatelessWidget {
  const PlnPraCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DolphinAppBar.appBar1(automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.only(bottom: 24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Image.asset("assets/images/ic_green_check.png", height: 96.r),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.r),
                  child: Text(
                    "Transaksi Berhasil",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: DolphinButton.outlinedButton1(
                context,
                label: "Kembali ke halaman utama",
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
