// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predict_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictPayload _$PredictPayloadFromJson(Map<String, dynamic> json) =>
    PredictPayload(
      botThinkConfig: BotThinkConfig.fromJson(
          json['botThinkConfig'] as Map<String, dynamic>),
      owner: json['owner'] as String,
      botId: json['botId'] as String,
      botName: json['botName'] as String,
      persona: json['persona'] as String,
      sessionId: json['sessionId'] as String,
      language: json['language'] as String,
      question:
          (json['question'] as List<dynamic>).map((e) => e as String).toList(),
      dolphinLicense: json['dolphinLicense'] as String,
      ticketNumber: json['ticketNumber'] as String,
      channelId: json['channelId'] as String,
      channelType: json['channelType'] as String,
    );

Map<String, dynamic> _$PredictPayloadToJson(PredictPayload instance) =>
    <String, dynamic>{
      'botThinkConfig': BotThinkConfig.toJson(instance.botThinkConfig),
      'owner': instance.owner,
      'botId': instance.botId,
      'botName': instance.botName,
      'persona': instance.persona,
      'sessionId': instance.sessionId,
      'language': instance.language,
      'question': instance.question,
      'dolphinLicense': instance.dolphinLicense,
      'ticketNumber': instance.ticketNumber,
      'channelId': instance.channelId,
      'channelType': instance.channelType,
    };

BotThinkConfig _$BotThinkConfigFromJson(Map<String, dynamic> json) =>
    BotThinkConfig(
      confident: (json['confident'] as num).toInt(),
      maxDocumentLimit: (json['maxDocumentLimit'] as num).toInt(),
      documentTokenLength: (json['documentTokenLength'] as num).toInt(),
      documentRelevancy: json['documentRelevancy'] as bool,
      processFlowRelevancy: json['processFlowRelevancy'] as bool,
      reRank: json['reRank'] as bool,
      maxDocumentRetryLimit: (json['maxDocumentRetryLimit'] as num).toInt(),
      retainHistoryFallback: json['retainHistoryFallback'] as bool,
    );

Map<String, dynamic> _$BotThinkConfigToJson(BotThinkConfig instance) =>
    <String, dynamic>{
      'confident': instance.confident,
      'maxDocumentLimit': instance.maxDocumentLimit,
      'documentTokenLength': instance.documentTokenLength,
      'documentRelevancy': instance.documentRelevancy,
      'processFlowRelevancy': instance.processFlowRelevancy,
      'reRank': instance.reRank,
      'maxDocumentRetryLimit': instance.maxDocumentRetryLimit,
      'retainHistoryFallback': instance.retainHistoryFallback,
    };
