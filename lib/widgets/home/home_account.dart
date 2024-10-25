import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAccount extends StatelessWidget {
  const HomeAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.r, 16.r, 8.r, 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tabungan & Deposito',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          _buildAccountCard('Tabungan Mandiri', '1340025729301', context),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
      String accountName, String accountNumber, BuildContext context) {
    return AccountCard(accountNumber: accountNumber,);
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.accountNumber,
  });
  final String accountNumber;
  final kCardHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/images/img_mandiri_debit_gold.png",
                  height: kCardHeight.r,
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 64.r),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: kCardHeight.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.r, 0, 8.r, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tabungan Mandiri",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          accountNumber,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
