import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebViewAppBar extends StatelessWidget {
  const WebViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4.r,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      shadowColor: Colors.black26,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: Image.asset("assets/images/ic_bella.png"),
      ),
      title: const Text(
        "BELLA",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff3E3E3E),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.cancel))
      ],
    );
  }
}
