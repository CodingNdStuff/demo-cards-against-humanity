// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_lobby_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLobbyResponse _$CreateLobbyResponseFromJson(Map<String, dynamic> json) =>
    CreateLobbyResponse(
      json['lobbyId'] as String,
      json['playerId'] as String,
    );

Map<String, dynamic> _$CreateLobbyResponseToJson(
        CreateLobbyResponse instance) =>
    <String, dynamic>{
      'lobbyId': instance.lobbyId,
      'playerId': instance.playerId,
    };
