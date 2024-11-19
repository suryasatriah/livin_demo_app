import 'package:dolphin_livin_demo/screens/transfer/transfer_success_screen.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:dolphin_livin_demo/widgets/home/home_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransferScreen extends StatefulWidget {
  final String transferAmount;
  final String transferDestination;
  final String destinationName;

  const TransferScreen(
      {super.key,
      this.transferAmount = "0",
      this.transferDestination = "10024520240810",
      this.destinationName = "Andriansyah Hakim"});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    try {
      textEditingController.text = NumberFormat("#,##0.00", "en_US").format(double.tryParse(widget.transferAmount));
    } catch (e) {
      DolphinLogger.instance.e(e);
      textEditingController.text = widget.transferAmount;
    }
    
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
    // Split the name by spaces
    List<String> words = name.split(" ");

    // Take the first letter of each word and join them, then limit to 2 letters
    String initials = words
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    // Return only the first 2 characters
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            backgroundColor: Colors.white,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: Container(
                            color: Colors
                                .blue, // Background color of the rectangle
                            height: 50.r,
                            width: 50.r,
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
                        Text(
                          widget.destinationName.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Bank Mandiri - ${widget.transferDestination}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w300),
                        )
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
                                NumberFormat formatter = NumberFormat("#,##0.00", "en_US");
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
            ),
            // Account
            Container(
              color: const Color(0xfff6f6f6),
              padding: const EdgeInsets.all(8),
              height: 180.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Text(
                      "Rekening Sumber",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                  const AccountCard(accountNumber: "1340025729301"),
                ],
              ),
            ),
            // Bottom Actions

            Image.asset("assets/images/img_transfer_actions.jpg"),
// Next Button
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransferSuccessScreen(
                                      destinationName: widget.destinationName,
                                      transferAmount: widget.transferAmount,
                                      transferDestination:
                                          widget.transferDestination,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff007dfe), // Button background color
                        foregroundColor:
                            Colors.white, // Text color (foreground)
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.r), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Lanjutkan',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
