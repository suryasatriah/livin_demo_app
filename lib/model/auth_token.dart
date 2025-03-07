import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

@JsonSerializable()
class AuthToken {
  String token;
  
  @JsonKey(fromJson: expireAtFromJson)
  DateTime? expireAt;

  AuthToken({
    this.token = "",
    this.expireAt,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  static DateTime expireAtFromJson(String dateString) {
    String formattedDate = dateString.split('[')[0];
    return DateTime.parse(formattedDate);
  }

  bool isTokenExpired() => expireAt?.isBefore(DateTime.now()) == true;
}
