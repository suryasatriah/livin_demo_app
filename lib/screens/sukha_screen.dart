import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SukhaScreen extends StatelessWidget {
  const SukhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Image.asset(
              "assets/images/img_sukha_screen.jpg",
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context)
                  .size
                  .width, // Set the width to fit the screen
            ),
          ),
          Positioned(
            top: 32.r, // Adjust the distance from the top
            right: 16, // Adjust the distance from the right
            child: FloatingActionButton.small(
              onPressed: () => Navigator.pop(context),
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
