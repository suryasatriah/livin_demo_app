import 'dart:ui';

import 'package:dolphin_livin_demo/model/result.dart';
import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final DolphinApi dolphinApi = DolphinApi.instance;
  late List<String> suggestions;

  bool loading = true;
  bool submitted = false;
  Result? answer;
  String? link;
  String? buttonLabel;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    init();
  }

  init() async {
    try {
      suggestions = await dolphinApi.getSuggestions() ?? [];
    } catch (e) {
      DolphinLogger.instance.e(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  doSubmitSearch() async {
    try {
      setState(() {
        loading = true;
      });
      var newAnswer = await dolphinApi.getResult(controller.text);
      if (newAnswer?.title != null && newAnswer!.title!.isNotEmpty) {
        setState(() {
          answer = newAnswer;
          buttonLabel = newAnswer.button?.split('@===@')[2];
          link = newAnswer.button?.split('@===@')[1];
          submitted = true;
          loading = false;
        });
      }
    } catch (e) {
      DolphinLogger.instance.e(e);
      setState(() {
        loading = false;
      });
    }
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
                  onTap: () => setState(() {
                    controller.text = suggestions[index];
                    doSubmitSearch();
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
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer?.title ?? "Answer not available",
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
                buttonLabel ?? 'Not Set',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              contentPadding: const EdgeInsets.all(0),
              trailing: IconButton(
                // onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const PlnPraScreen())),
                onPressed: () async {
                  if (link != null) {
                    final uri = Uri.parse(link!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $link';
                    }
                  }
                },
                icon: const Icon(
                  Icons.arrow_outward,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget buildShimmer() {
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
            )),
      );
    }

    return PopScope(
      canPop: !loading,
      child: BackdropFilter(
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
                  onTap: () => Navigator.pop(context),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
                  child: SingleChildScrollView(
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
                          onFieldSubmitted: (value) => doSubmitSearch(),
                          onTapOutside: (event) => focusNode.unfocus(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.r),
                          child: loading
                              ? buildShimmer()
                              : submitted
                                  ? buildAnswer()
                                  : buildSuggestions(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
