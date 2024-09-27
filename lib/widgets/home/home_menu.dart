import 'package:dolphin_livin_demo/constant.dart';
import 'package:dolphin_livin_demo/screens/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  late Future<void> _menuItemsFuture;
  Map<String, Map<String, dynamic>> menuItems = {};

  @override
  void initState() {
    super.initState();
    _menuItemsFuture = populateMenuItems();
  }

  Future<void> populateMenuItems() async {
    // Simulate a delay for fetching data (if needed)
    await Future.delayed(const Duration(seconds: 1)); // Optional delay

    menuItems = {
      'assets/images/ic_menu_transfer.png': {
        'label': 'Transfer Rupiah',
        'onTap': null,
      },
      'assets/images/ic_menu_va.png': {
        'label': 'Bayar/VA',
        'onTap': null,
      },
      'assets/images/ic_menu_topup.png': {
        'label': 'Top-Up',
        'onTap': null,
      },
      'assets/images/ic_menu_emoney.png': {
        'label': 'E-money',
        'onTap': null,
      },
      'assets/images/ic_menu_sukha.png': {
        'label': 'Sukha',
        'onTap': null,
      },
      'assets/images/ic_menu_transfer_valas.png': {
        'label': 'Transfer Valas',
        'onTap': null,
      },
      'assets/images/ic_menu_qris.png': {
        'label': 'QRIS',
        'onTap': null,
      },
      'assets/images/ic_menu_kpr.png': {
        'label': 'KPR',
        'onTap': null,
      },
      'assets/images/ic_menu_tap_to_pay.png': {
        'label': 'Tap to Pay',
        'onTap': null,
      },
      'assets/images/ic_menu_investasi.png': {
        'label': 'Investasi',
        'onTap': navigateToWebChat,
      }
    };
  }

  void navigateToWebChat() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const WebViewScreen(url: kLiveChatEndpoint)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _menuItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 8.r, 0, 8.r),
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
                  child: GridView.count(
                    crossAxisCount: 5,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 10.r,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: menuItems.entries.map((entry) {
                      String asset = entry.key;
                      String label = entry.value['label']!;
                      Function()? onTap = entry.value['onTap'];
                      return buildMenuButton(asset, label, onTap: onTap);
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget buildMenuButton(String asset, String label, {Function()? onTap}) {
    return Container(
      height: 120.r,
      padding: EdgeInsets.fromLTRB(8.r, 0, 8.r, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Image.asset(
                asset,
                width: 40.r,
                height: 40.r,
              ),
            ),
          ),
          Container(
            height: 40.r,
            padding: EdgeInsets.fromLTRB(0, 8.r, 0, 0),
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w300),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
