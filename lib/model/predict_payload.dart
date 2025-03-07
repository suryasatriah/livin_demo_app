import 'package:json_annotation/json_annotation.dart';

part 'predict_payload.g.dart';

@JsonSerializable()
class PredictPayload {
  @JsonKey(toJson: BotThinkConfig.toJson, fromJson: BotThinkConfig.fromJson)
  final BotThinkConfig botThinkConfig;
  final String owner;
  final String botId;
  final String botName;
  final String persona;
  final String sessionId;
  final String language;
  final List<String> question;
  final String dolphinLicense;
  final String ticketNumber;
  final String channelId;
  final String channelType;

  PredictPayload({
    required this.botThinkConfig,
    required this.owner,
    required this.botId,
    required this.botName,
    required this.persona,
    required this.sessionId,
    required this.language,
    required this.question,
    required this.dolphinLicense,
    required this.ticketNumber,
    required this.channelId,
    required this.channelType,
  });

  factory PredictPayload.fromJson(Map<String, dynamic> json) =>
      _$PredictPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PredictPayloadToJson(this);
}

@JsonSerializable()
class BotThinkConfig {
  final int confident;
  final int maxDocumentLimit;
  final int documentTokenLength;
  final bool documentRelevancy;
  final bool processFlowRelevancy;
  final bool reRank;
  final int maxDocumentRetryLimit;
  final bool retainHistoryFallback;

  BotThinkConfig({
    required this.confident,
    required this.maxDocumentLimit,
    required this.documentTokenLength,
    required this.documentRelevancy,
    required this.processFlowRelevancy,
    required this.reRank,
    required this.maxDocumentRetryLimit,
    required this.retainHistoryFallback,
  });

  factory BotThinkConfig.fromJson(Map<String, dynamic> json) =>
      _$BotThinkConfigFromJson(json);

  static Map<String, dynamic> toJson(BotThinkConfig instance) =>
      _$BotThinkConfigToJson(instance);
}
