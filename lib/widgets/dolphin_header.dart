import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DolphinHeader extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget? picture;

  const DolphinHeader(
      {super.key, required this.title, this.subTitle, this.picture});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            color: Colors.blue,
            height: 50.r,
            width: 50.r,
            alignment: Alignment.center,
            child: picture,
          ),
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        if (subTitle != null)
          Text(
            subTitle!,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w300),
          ),
      ],
    );
  }
}
