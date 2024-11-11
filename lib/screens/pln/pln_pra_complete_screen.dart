import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_button.dart';
import 'package:dolphin_livin_demo/widgets/explorer/explorer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PlnPraCompleteScreen extends StatefulWidget {
  const PlnPraCompleteScreen({super.key});

  @override
  State<PlnPraCompleteScreen> createState() => _PlnPraCompleteScreenState();
}

class _PlnPraCompleteScreenState extends State<PlnPraCompleteScreen> {
  late ExplorerProvider explorerProvider;

  @override
  void initState() {
    super.initState();
    explorerProvider = Provider.of<ExplorerProvider>(context, listen: false);
  }

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
                  child: DolphinButton.outlinedButton1(context,
                      label: "Kembali ke halaman utama",
                      // onPressed: () => {
                      //   explorerProvider.clearData(),
                      //   GoRouter.of(context).go('/'),
                      // },
                      onPressed: () {
                    explorerProvider.clearData();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }))
            ]),
      ),
    );
  }
}
