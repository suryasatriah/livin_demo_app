import 'package:dolphin_livin_demo/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeaderMenu extends StatelessWidget {
  final String label;
  final String name;

  const HomeHeaderMenu({
    super.key,
    required this.label,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageButton(
          name: name,
          height: 40.r,
        ),
        Text(label),
      ],
    );
  }
}
