import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late FocusNode focusNode;
  late TextEditingController controller;

  List<String> suggestions = ["bayar listrik"];
  bool canPop = true;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSuggestions() {
      if (suggestions.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SUGGESTION",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontSize: 14.sp, color: const Color(0xff7A7E87)),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.all(0),
                minTileHeight: 0,
                dense: true,
                title: InkWell(
                  onTap:() => setState(() {
                    submitted = true;
                  }),
                  child: Text(
                    suggestions[index],
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    }

    Widget buildAnswer() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Anda terakhir kali membayar tagihan listrik pada 08 November untuk nomor pelanggan 543106161818. Ayo, lanjutkan pembayaran untuk tagihan berikutnya agar layanan tetap lancar.",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.r),
            child: Divider(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          ListTile(
            title: Text(
              "PLN",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            contentPadding: const EdgeInsets.all(0),
            trailing: const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.arrow_outward,
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    }

    return BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjusts blur effect
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: const Color(0xff171D2C).withOpacity(0.7),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => canPop ? Navigator.pop(context) : null,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfffeffff).withOpacity(0.1),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.r, horizontal: 8.r),
                          child: Image.asset(
                            "assets/images/home/ic_home_search.png",
                            height: 8.r,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2))),
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
                      onTapOutside: (event) => focusNode.unfocus(),
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.r),
                      child: submitted ? buildAnswer() : buildSuggestions(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
