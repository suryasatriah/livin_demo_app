import 'package:json_annotation/json_annotation.dart';

part 'bot.g.dart';

@JsonSerializable()
class Bot {
  final String id;
  final String owner;
  final int createdDate;
  final String createdBy;
  final int modifiedDate;
  final String modifiedBy;
  final String botName;
  final List<String> botPersona;
  final String activationText;
  final String activationCommand;
  final int dialogTimeout;
  final int domainTimeout;
  final String language;

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
  });

  factory Bot.fromJson(Map<String, dynamic> json) => _$BotFromJson(json);

  Map<String, dynamic> toJson() => _$BotToJson(this);
}
