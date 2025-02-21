import 'package:dolphin_livin_demo/constants/constant_asset.dart';
import 'package:dolphin_livin_demo/constants/constant_base.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_amt_view.dart';
import 'package:dolphin_livin_demo/widgets/button/dolphin_elevated_button1.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/dolphin_dropdown_menu1.dart';
import 'package:dolphin_livin_demo/widgets/text_input/dolphin_text_input1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferView extends StatefulWidget {
  final String? amount;
  final String? destination;

  const TransferView({
    super.key,
    this.amount,
    this.destination,
  });

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  late TextEditingController controller;
  late TextEditingController menuController;
  late FocusNode focusNode;

  var canContinue = false;
  var destinationBank;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    if (widget.destination != null) {
      controller.text = widget.destination!;
      canContinue = true;
    }
    menuController = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    menuController.dispose();
    super.dispose();
  }

  onChanged(String value) {
    setState(() {
      canContinue = value.isNotEmpty == true;
    });
  }

  onMenuChange(String? value) {
    destinationBank = value;
  }

  @override
  Widget build(BuildContext context) {
    void navigateToTransferAmt() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransferAmtView(
                  amount: widget.amount,
                  destination: controller.text,
                  destinationBank: menuController.text,
                )));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DolphinAppBar.appBar1(automaticallyImplyLeading: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(ConstantAsset.kAssetImgTransferHeader),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.r),
                          child: DolphinDropdownMenu1<String>(
                            controller: menuController,
                            dropdownMenuEntries:
                                ConstantBase.kListBankDropdownMenu,
                            label: "Nama Bank",
                            onChanged: (value) => onMenuChange(value),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.r),
                          child: DolphinTextInput1(
                            controller: controller,
                            focusWhenOpen: true,
                            keyboardType: TextInputType.number,
                            label: "Nomor Rekening",
                            onChanged: (value) => onChanged(value),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24.r),
              child: Row(
                children: [
                  Expanded(
                    child: DolphinElevatedButton1(
                      label: "Lanjutkan",
                      onPressed:
                          canContinue ? () => navigateToTransferAmt() : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
