import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kButtonColor = 0xff007dfe;
const kHeadlineTextColor = Color(0xff163a88);

final kHeadlineSmallTextStyle = TextStyle(
  color: kHeadlineTextColor,
  fontSize: 18.sp,
);
const kBodyLargeTextStyle = TextStyle(
  color: Colors.black,
);
const kBodyMediumTextStyle = TextStyle(
  color: Colors.black,
);

final kLabelMediumTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.sp,
);

final kLabelLargeTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.sp,
);

const kTitleMediumTextStyle = TextStyle(
  color: Colors.black,
);

const kTitleLargeTextStyle = TextStyle(
  color: Colors.black,
);

// const kLiveChatEndpoint =
//     "https://mandiri.3dolphins.ai:9443/webchat/livechat-livin.html?name=Reza&email=reza@gmail.com&triggerMenu=financial%20insight";

const kLiveChatEndpoint =
    "https://mandiri.3dolphins.ai:9443/livechat-mandiri-livin/livechat-livin.html";

const kGenerativeUrl = "https://generative.3dolphins.ai:9443";
const kBasicPredictPayload = {
  "language": "indonesia",
  "botId": "xxxxx",
  "documentId": ["xxxxx"],
  "persona": "xxxxx",
  "botName": "xxxx",
  "channelType": "xxxxxx",
  "owner": "xxxxx",
  "dolphinLicense": "xxxxxx",
  "botThinkConfig": {
    "confident": 0,
    "maxDocumentLimit": 0,
    "documentTokenLength": 0,
    "documentRelevancy": true,
    "processFlowRelevancy": true,
    "reRank": true,
    "retainHistoryFallback": true
  }
};
