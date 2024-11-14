import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageButton extends StatelessWidget {
  final String name;
  final Function()? onTap;
  final double? height;

  const ImageButton({
    super.key,
    required this.name,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(name, height: height ?? 24.r),
      ),
    );
  }
}
