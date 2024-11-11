import 'package:dolphin_livin_demo/screens/pln/pln_pra_amt_screen.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_button.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlnPraScreen extends StatefulWidget {
  final String? amount;
  final String? destination;

  const PlnPraScreen({super.key, this.amount, this.destination});

  @override
  State<PlnPraScreen> createState() => _PlnPraScreenState();
}

class _PlnPraScreenState extends State<PlnPraScreen> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    if (widget.destination != null) controller.text = widget.destination!;
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DolphinAppBar.appBar1(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 24.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.r),
              child: DolphinHeader(
                title: "PLN Prabayar",
                picture: Image.asset("assets/images/ic_pln.png"),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide:
                                  const BorderSide(color: Colors.black)),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton.filled(
                                onPressed: () => setState(() {
                                      controller.text = '';
                                    }),
                                color: Colors.white,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.clear_outlined)),
                          ),
                        ),
                        focusNode: focusNode,
                        onTapOutside: (event) => focusNode.unfocus(),
                      )),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                    child: DolphinButton.outlinedButton1(context,
                        label: "Lanjutkan",
                        onPressed: () => controller.text.isNotEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlnPraAmtScreen(
                                        amount: widget.amount,
                                        destination: controller.text)))
                            : null),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
