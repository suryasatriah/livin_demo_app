import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DolphinElevatedButton1 extends StatefulWidget {
  final String label;
  final void Function()? onPressed;

  const DolphinElevatedButton1(
      {super.key, required this.label, this.onPressed});

  @override
  State<DolphinElevatedButton1> createState() => _DolphinElevatedButton1State();
}

class _DolphinElevatedButton1State extends State<DolphinElevatedButton1> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff007dfe), // Button background color
        foregroundColor: Colors.white, // Text color (foreground)
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r), // Rounded corners
        ),
      ),
      child: Text(
        'Lanjutkan',
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
