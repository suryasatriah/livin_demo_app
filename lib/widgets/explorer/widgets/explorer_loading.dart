import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ExplorerLoading extends StatelessWidget {
  const ExplorerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff656BC8).withOpacity(0.2),
      highlightColor: const Color(0xff3F46BB).withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              width: index == 2 ? 64.r : double.infinity,
              height: 18.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
