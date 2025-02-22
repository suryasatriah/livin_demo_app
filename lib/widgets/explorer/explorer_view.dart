import 'dart:ui';

import 'package:dolphin_livin_demo/core/permission_handler.dart';
import 'package:dolphin_livin_demo/model/result.dart';
import 'package:dolphin_livin_demo/services/dolphin_deeplink_redirect.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:dolphin_livin_demo/widgets/explorer/explorer_provider.dart';
import 'package:dolphin_livin_demo/widgets/explorer/widgets/explorer_answer_generator.dart';
import 'package:dolphin_livin_demo/widgets/explorer/widgets/explorer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ExplorerView extends StatefulWidget {
  const ExplorerView({
    super.key,
  });

  @override
  State<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends State<ExplorerView>
    with DolphinDeepLinkNavigator {
  late FocusNode focusNode;
  late TextEditingController controller;

  late ExplorerProvider explorerProviderWidget;

  final DolphinLogger dolphinLogger = DolphinLogger.instance;
  bool submitted = false;
  Result? answer;
  String? link;
  String? buttonLabel;

  @override
  void initState() {
    super.initState();
    PermissionHandler().listenForPermissions();
    focusNode = FocusNode();
    controller = TextEditingController();
    init();
  }

  init() async {
    explorerProviderWidget =
        Provider.of<ExplorerProvider>(context, listen: false);
    try {
      await explorerProviderWidget.populateSuggestion();
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
      Fluttertoast.showToast(
          msg:
              "Cannot retrieve suggestions right now. Please try again later.");
    }

    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    explorerProviderWidget.clearData();
    super.dispose();
  }

  doSubmitSearch(ExplorerProvider explorerProvider) async {
    if (!explorerProvider.loading && controller.text.length > 3) {
      explorerProvider.submitSearch();
    }
  }

  ///
  /// Text to speech mechanism
  ///
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = "";

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    dolphinLogger.i("_startListening()");
    await _speechToText.listen(
      onResult: _onResult,
      listenFor: const Duration(seconds: 30),
      localeId: "id_ID",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );

    explorerProviderWidget.clearData();
    setState(() {
      _isListening = true;
      controller.text = "";
      _lastWords = "";
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    dolphinLogger.i("_stopListening()");
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onResult(SpeechRecognitionResult result) {
    dolphinLogger.i("_onSpeechResult() result: $result");
    setState(() {
      _isListening = false;

      _lastWords = "$_lastWords${result.recognizedWords} ";
      controller.text = _lastWords;
      var explorerProvider =
          Provider.of<ExplorerProvider>(context, listen: false);
      if (!explorerProvider.loading && controller.text.length > 3) {
        explorerProvider.submitSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !Provider.of<ExplorerProvider>(context).loading,
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
                  onTap: () => {
                    if (!Provider.of<ExplorerProvider>(context, listen: false)
                        .loading)
                      Navigator.pop(context)
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          buildInputForm(context),
                          Padding(
                            padding: EdgeInsets.only(top: 20.r),
                            child: buildExplorerContents(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.r),
                            child: buildVoiceRow(context),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSuggestions(ExplorerProvider explorerProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isListening) Text(
          "SUGGESTION",
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontSize: 14.sp, color: const Color(0xff7A7E87)),
        ),
        if (explorerProvider.suggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: explorerProvider.suggestions.length,
            itemBuilder: (context, index) => ListTile(
              contentPadding: const EdgeInsets.all(0),
              minTileHeight: 0,
              dense: true,
              title: InkWell(
                onTap: () {
                  setState(() {
                    controller.text = explorerProvider.suggestions[index];
                  });
                  doSubmitSearch(explorerProvider);
                },
                child: Text(
                  explorerProvider.suggestions[index],
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

  buildAnswer() {
    return Column(
      children: [
        Selector<ExplorerProvider, Result?>(
          selector: (context, explorerProvider) => explorerProvider.result,
          builder: (context, explorerProvider, child) =>
              ExplorerAnswerGenerator(
            question: controller.text,
          ),
        ),
      ],
    );
  }

  Widget buildExplorerContents() {
    if (!explorerProviderWidget.loading) {
      if (!explorerProviderWidget.submitted) {
        return buildSuggestions(explorerProviderWidget);
      } else {
        return buildAnswer();
      }
    } else {
      return const ExplorerLoading();
    }
  }

  Widget buildInputForm(BuildContext context) {
    return TextFormField(
      autofocus: true,
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
        suffixIcon: IconButton(
            onPressed: explorerProviderWidget.submitted
                ? () => {
                      setState(() {
                        controller.text = '';
                        _lastWords = '';
                        explorerProviderWidget.clearData();
                        explorerProviderWidget.populateSuggestion();
                      })
                    }
                : null,
            icon: const Icon(Icons.clear)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
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
        hintText: "Apa yang anda butuhkan?",
        hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.6)),
      ),
      focusNode: focusNode,
      onFieldSubmitted: (value) => doSubmitSearch(explorerProviderWidget),
      onTapOutside: (event) => focusNode.unfocus(),
      style: Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(fontWeight: FontWeight.w400),
    );
  }
  Widget buildVoiceRow(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            (_isListening)
                ? Padding(
                    padding: EdgeInsets.only(bottom: 8.r),
                    child: Text(
                      "Listening...",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  )
                : const SizedBox.shrink(),
            CircleAvatar(
              radius: 30,
              backgroundColor: (_isListening) ? Colors.red : Colors.grey,
              child: IconButton(
                icon: const Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
