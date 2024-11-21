import 'package:dolphin_livin_demo/constants/constant_base.dart';
import 'package:dolphin_livin_demo/constants/constant_color.dart';
import 'package:dolphin_livin_demo/screens/transfer/transfer_success_screen.dart';
import 'package:dolphin_livin_demo/widgets/button/dolphin_elevated_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransferAmtView extends StatefulWidget {
  final String? amount;
  final String destination;
  final String destinationBank;
  final String destinationName;

  const TransferAmtView(
      {super.key,
      this.amount,
      this.destination = "10024520240810",
      this.destinationBank = "Bank Mandiri",
      this.destinationName = "Andriansyah Hakim"});

  @override
  State<TransferAmtView> createState() => _TransferAmtViewState();
}

class _TransferAmtViewState extends State<TransferAmtView> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  late String amount;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();
    textEditingController.text = widget.amount ?? "0";
    amount = widget.amount ?? "0";
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  String getInitials(String name) {
    List<String> words = name.split(" ");
    String initials = words
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  getDestinationBankLabel(String value) {
    try {
      return ConstantBase.kListBankDropdownMenu
          .firstWhere((entry) => entry.value == value)
          .label;
    } catch (e) {
      return "Bank Mandiri";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Colors.white,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.r),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(32.r),
                                  child: Container(
                                    color: Colors.blue,
                                    height: 56.r,
                                    width: 56.r,
                                    alignment: Alignment.center,
                                    child: Text(
                                      getInitials(widget.destinationName),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18, // Adjust font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                widget.destinationName.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                              ),
                              Text(
                                "${getDestinationBankLabel(widget.destinationBank)} - ${widget.destination}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Text(
                              "Nominal",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 0),
                            child: Text("Rp",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black,
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: focusNode,
                              onTapOutside: (event) => focusNode.unfocus(),
                              controller: textEditingController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  // Remove commas from the new input
                                  String newText =
                                      newValue.text.replaceAll(',', '');
        
                                  // If the newText is empty, set the value to 0
                                  if (newText.isEmpty) {
                                    newText = '0';
                                  }
        
                                  // Try to parse the input into an integer
                                  int? value = int.tryParse(newText);
                                  if (value == null) {
                                    return oldValue; // If parsing fails, return the old value
                                  }
        
                                  // Format the integer with commas
                                  NumberFormat formatter = NumberFormat('#,##0');
                                  String formattedValue = formatter.format(value);
        
                                  // Return the formatted value as a new TextEditingValue
                                  return TextEditingValue(
                                    text: formattedValue,
                                    selection: TextSelection.collapsed(
                                        offset: formattedValue.length),
                                  );
                                })
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.w500),
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              textEditingController.text = '0';
                              setState(() {});
                            },
                            icon: const Icon(Icons.cancel),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Color(ConstantColorHex.kColorHexBg1)),
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 16.r),
                            child: Image.asset(
                                "assets/images/transfer/img_transfer_account.jpg")),
                      ),
                      Image.asset(
                          "assets/images/transfer/img_transfer_action.jpg"),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: DolphinElevatedButton1(
                            label: "Lanjutkan",
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TransferSuccessScreen(
                                          destinationName: widget.destinationName,
                                          transferAmount: amount,
                                          transferDestination: widget.destination,
                                        )))))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
