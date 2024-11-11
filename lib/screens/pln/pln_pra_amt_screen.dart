import 'package:dolphin_livin_demo/screens/pln/pln_pra_complete_screen.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_button.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PlnPraAmtScreen extends StatelessWidget {
  final String? amount;
  final String destination;

  const PlnPraAmtScreen({super.key, this.amount, required this.destination});

  @override
  Widget build(BuildContext context) {
    final NumberFormat occY = NumberFormat("#,##0.00", "en_US");
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
            if (amount != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("IDR ${occY.format(double.tryParse(amount!))}",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 32.sp, fontWeight: FontWeight.w500))
                ],
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
