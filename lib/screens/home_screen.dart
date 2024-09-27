import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/widgets/home/home_account.dart';
import 'package:dolphin_livin_demo/widgets/home/home_app_bar.dart';
import 'package:dolphin_livin_demo/widgets/home/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: HomeAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 8.r, 0, 8.r),
                        child: Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Selamat siang, ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              TextSpan(
                                text: 'SURYA!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/img_quick_pick.png",
                        width: 100.r,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 0),
                          child: Column(
                            children: [
                              Text(
                                'Mau transfer, bayar, dan top up lebih cepat?',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(kButtonColor),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Atur Sekarang',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const HomeMenu(),
            const HomeAccount(),
          ],
        ),
      ),
    );
  }

  


  Widget _buildEwalletSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('e-Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEwalletCard('GoPay', 'Rp 20.518'),
              _buildEwalletCard('OVO', 'Rp 44.655'),
              _buildEwalletCard('Dana', 'Rp 1.000'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEwalletCard(String ewalletName, String balance) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(ewalletName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(balance),
            ],
          ),
        ),
      ),
    );
  }
}
