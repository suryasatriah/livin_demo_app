import 'package:json_annotation/json_annotation.dart';

part 'bot.g.dart';

@JsonSerializable()
class Bot {
  String id;
  String owner;
  int createdDate;
  String createdBy;
  int modifiedDate;
  String modifiedBy;
  String botName;
  List<String> botPersona;
  String activationText;
  String activationCommand;
  int dialogTimeout;
  int domainTimeout;
  String language;
  int confident;
  int maxDocumentLimit;
  int documentTokenLength;
  bool documentRelevancy;
  bool processFlowRelevancy;
  bool reRank;
  int maxDocumentRetryLimit;
  bool retainHistoryFallback;

  Bot({
    this.id = "",
    this.owner = "",
    this.createdDate = 0,
    this.createdBy = "",
    this.modifiedDate = 0,
    this.modifiedBy = "",
    this.botName = "",
    this.botPersona = const [],
    this.activationText = "",
    this.activationCommand = "",
    this.dialogTimeout = 0,
    this.domainTimeout = 0,
    this.language = "",
    this.confident = 0,
    this.maxDocumentLimit = 0,
    this.documentTokenLength = 0,
    this.documentRelevancy = false,
    this.processFlowRelevancy = false,
    this.reRank = false,
    this.maxDocumentRetryLimit = 0,
    this.retainHistoryFallback = false,
  });

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);

  Map<String, dynamic> toJson() => _$BotToJson(this);
}
