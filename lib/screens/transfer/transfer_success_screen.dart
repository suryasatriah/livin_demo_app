import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TransferSuccessScreen extends StatefulWidget {
  final String transferAmount;
  final String transferDestination;
  final String destinationName;

  const TransferSuccessScreen(
      {super.key,
      this.transferAmount = "0",
      this.transferDestination = "10024520240810",
      this.destinationName = "Andriansyah Hakim"});

  @override
  State<TransferSuccessScreen> createState() => _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends State<TransferSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: const Color(0xfff6f6f6),
            leading: null,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () =>  GoRouter.of(context).go('/'),
                  icon: const Icon(Icons.cancel))
            ],
          )),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset("assets/images/ic_green_check.png", width: 100.r),
                  Text(
                    "Transfer Berhasil",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.r, 0, 8.r, 50.r),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.r, 25.r, 8.r, 25.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Penerima",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black54),
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
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      Text(
                        "Nominal",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black54),
                      ),
                      Text(
                        "Rp ${widget.transferAmount}",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Dari REZA PRATAMA",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
