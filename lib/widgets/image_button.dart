import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatelessWidget {
  final String asset;
  final Function()? onTap;
  final double? height;
  final double? width;

  const ImageButton({
    super.key,
    required this.asset,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(asset, height: 24.r),
      ),
    );
  }
}
