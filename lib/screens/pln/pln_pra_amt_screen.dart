import 'package:dolphin_livin_demo/screens/pln/pln_pra_complete_screen.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_button.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlnPraAmtScreen extends StatelessWidget {
  final String destination;

  const PlnPraAmtScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DolphinAppBar.appBar1(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.r),
              child: DolphinHeader(
                title: "PLN Prabayar",
                subTitle: destination,
                picture: Image.asset("assets/images/ic_pln.png"),
              ),
            ),
            Image.asset("assets/images/img_pln_amount.jpg"),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
              child: DolphinButton.outlinedButton1(
                context,
                label: "Lanjutkan",
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlnPraCompleteScreen())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
