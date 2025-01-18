// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_lobby_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLobbyRequest _$CreateLobbyRequestFromJson(Map<String, dynamic> json) =>
    CreateLobbyRequest(
      json['nickname'] as String,
      (json['roundDuration'] as num).toInt(),
      (json['maxRoundNumber'] as num).toInt(),
    );

Map<String, dynamic> _$CreateLobbyRequestToJson(CreateLobbyRequest instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'roundDuration': instance.roundDuration,
      'maxRoundNumber': instance.maxRoundNumber,
    };
