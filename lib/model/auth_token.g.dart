// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) => AuthToken(
      token: json['token'] as String? ?? "",
      expireAt: AuthToken.expireAtFromJson(json['expireAt'] as String),
    );

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
      'token': instance.token,
      'expireAt': instance.expireAt?.toIso8601String(),
    };
