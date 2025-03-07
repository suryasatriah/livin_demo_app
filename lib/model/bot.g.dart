// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bot _$BotFromJson(Map<String, dynamic> json) => Bot(
      id: json['id'] as String? ?? "",
      owner: json['owner'] as String? ?? "",
      createdDate: (json['createdDate'] as num?)?.toInt() ?? 0,
      createdBy: json['createdBy'] as String? ?? "",
      modifiedDate: (json['modifiedDate'] as num?)?.toInt() ?? 0,
      modifiedBy: json['modifiedBy'] as String? ?? "",
      botName: json['botName'] as String? ?? "",
      botPersona: (json['botPersona'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activationText: json['activationText'] as String? ?? "",
      activationCommand: json['activationCommand'] as String? ?? "",
      dialogTimeout: (json['dialogTimeout'] as num?)?.toInt() ?? 0,
      domainTimeout: (json['domainTimeout'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? "",
      confident: (json['confident'] as num?)?.toInt() ?? 0,
      maxDocumentLimit: (json['maxDocumentLimit'] as num?)?.toInt() ?? 0,
      documentTokenLength: (json['documentTokenLength'] as num?)?.toInt() ?? 0,
      documentRelevancy: json['documentRelevancy'] as bool? ?? false,
      processFlowRelevancy: json['processFlowRelevancy'] as bool? ?? false,
      reRank: json['reRank'] as bool? ?? false,
      maxDocumentRetryLimit:
          (json['maxDocumentRetryLimit'] as num?)?.toInt() ?? 0,
      retainHistoryFallback: json['retainHistoryFallback'] as bool? ?? false,
    );

Map<String, dynamic> _$BotToJson(Bot instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
      'modifiedDate': instance.modifiedDate,
      'modifiedBy': instance.modifiedBy,
      'botName': instance.botName,
      'botPersona': instance.botPersona,
      'activationText': instance.activationText,
      'activationCommand': instance.activationCommand,
      'dialogTimeout': instance.dialogTimeout,
      'domainTimeout': instance.domainTimeout,
      'language': instance.language,
      'confident': instance.confident,
      'maxDocumentLimit': instance.maxDocumentLimit,
      'documentTokenLength': instance.documentTokenLength,
      'documentRelevancy': instance.documentRelevancy,
      'processFlowRelevancy': instance.processFlowRelevancy,
      'reRank': instance.reRank,
      'maxDocumentRetryLimit': instance.maxDocumentRetryLimit,
      'retainHistoryFallback': instance.retainHistoryFallback,
    };
