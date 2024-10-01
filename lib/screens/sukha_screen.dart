import 'package:flutter/material.dart';

class SukhaScreen extends StatelessWidget {
  const SukhaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Image.asset(
          "assets/images/img_sukha_screen.jpg",
          fit: BoxFit.fitWidth,
          width: MediaQuery.of(context)
              .size
              .width, // Set the width to fit the screen
        ),
      ),
    );
  }
}
