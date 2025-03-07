import 'package:dolphin_livin_demo/model/auth_token.dart';
import 'package:dolphin_livin_demo/model/bot.dart';
import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:flutter/material.dart';

class CoreNotifier extends ChangeNotifier {
  AuthToken authToken = AuthToken();
  Bot bot = Bot();
  DolphinApi api = DolphinApi.instance;

  // Future<String> getToken() async {
  //   if (authToken.isTokenExpired()) {
      
  //   }
  // }

  Future<void> populateBot() async {
    try {
      var botList = await api.fetchBotList(botId: "", token: '');
      bot = botList.first;
    } catch (e) {
      print(e);
    }
  }

}