import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/model/account.dart';
import 'package:dolphin_livin_demo/screens/home_xyz/widgets/home_header_menu.dart';
import 'package:dolphin_livin_demo/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final Color kTextColor1 = const Color(0xff040D38);

  final Account account = kAccount;

  bool balanceHidden = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tabungan Utama",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                Util.formatAccountNumber(account.number),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: kOrca300),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                color: kOrca300,
                                icon: const Icon(
                                  Icons.copy,
                                ),
                                iconSize: 16.r,
                                style: const ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () async => await Clipboard.setData(
                                    ClipboardData(
                                        text: account.number.toString())),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    balanceHidden
                        ? Row(
                            children: [
                              Image.asset(
                                "assets/images/home_xyz/ic_home_hidden_balance.png",
                                height: 8.r,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                ),
                                color: kTextColor1,
                                onPressed: () => setState(() {
                                  balanceHidden = !balanceHidden;
                                }),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "IDR ${Util.formatCurrency(account.balance)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: kTextColor1),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility_off,
                                ),
                                color: kTextColor1,
                                onPressed: () => setState(() {
                                  balanceHidden = !balanceHidden;
                                }),
                              )
                            ],
                          ),
                  ],
                ),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HomeHeaderMenu(
                      name: "assets/images/home_xyz/ic_home_transfer.png",
                      label: "Transfer",
                    ),
                    HomeHeaderMenu(
                      name: "assets/images/home_xyz/ic_home_va.png",
                      label: "Bayar VA",
                    ),
                    HomeHeaderMenu(
                      name: "assets/images/home_xyz/ic_home_wallet.png",
                      label: "E-Wallet",
                    ),
                    HomeHeaderMenu(
                      name: "assets/images/home_xyz/ic_home_history.png",
                      label: "Riwayat",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
