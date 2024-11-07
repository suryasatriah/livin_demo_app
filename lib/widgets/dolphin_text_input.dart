import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DolphinTextInput {
  static Widget defaultTextInput(
    BuildContext context, {
    bool autofocus = false,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfffeffff).withOpacity(0.1),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 8.r),
          child: Image.asset(
            "assets/images/home/ic_home_search.png",
            height: 8.r,
          ),
        ),
        label: const Text("Nomor pelanggan"),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.r),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        hintText: "Jelajahi fitur di sini",
        hintStyle: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(fontWeight: FontWeight.w400),
      ),
      focusNode: focusNode,
      onTapOutside: (event) => focusNode?.unfocus(),
      style: Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(fontWeight: FontWeight.w400),
    );
  }
}
