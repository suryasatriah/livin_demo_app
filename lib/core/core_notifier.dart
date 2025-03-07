import 'package:dolphin_livin_demo/model/auth_token.dart';
import 'package:dolphin_livin_demo/model/bot.dart';
import 'package:dolphin_livin_demo/model/user.dart';
import 'package:dolphin_livin_demo/services/dolphin_api.dart';
import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CoreNotifier extends ChangeNotifier {
  Bot bot = Bot();
  DolphinApi api = DolphinApi.instance;

  AuthToken authToken = AuthToken();
  DolphinLogger logger = DolphinLogger.instance;

  late String botId;
  late User user;

  CoreNotifier({
    required this.user,
    required this.botId,
  }) {
    init();
  }

  Future<void> init() async {
    await _populateAuthToken();
    await _populateBot();
    notifyListeners();
    logger.i("bot : $bot");
  }

  Future<String?> getToken() async {
    if (authToken.isTokenExpired()) {
      try {
        await _populateAuthToken(tokenExpired: true);
        return getToken();
      } catch (e) {
        logger.e(e);
        return null;
      }
    }
    return authToken.token;
  }

  Future<void> _populateAuthToken({bool tokenExpired = false}) async {
    var fetchedAuthToken = await (tokenExpired
        ? api.fetchAuthTokenByToken(authToken.token)
        : api.fetchAuthToken(user.username, user.password));
    if (fetchedAuthToken != null) {
      authToken = fetchedAuthToken;
    } else {
      throw Exception("failed to fetch authToken");
    }
  }

  Future<void> _populateBot() async {
    try {
      var bot = await api.fetchBot(botId: botId, token: authToken.token);
      if (bot != null) this.bot = bot;
    } catch (e, stack) {
      logger.e(e, stackTrace: stack);
    }
  }
}
