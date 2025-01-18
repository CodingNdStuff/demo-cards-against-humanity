// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LobbyDto _$LobbyDtoFromJson(Map<String, dynamic> json) => LobbyDto(
      json['id'] as String,
      $enumDecode(_$LobbyStatusEnumMap, json['status']),
      (json['roundDuration'] as num).toInt(),
      (json['maxRoundNumber'] as num).toInt(),
      (json['currentRound'] as num).toInt(),
      json['round'] == null
          ? null
          : RoundDto.fromJson(json['round'] as Map<String, dynamic>),
      json['currentBlackCard'] == null
          ? null
          : BlackCardDto.fromJson(
              json['currentBlackCard'] as Map<String, dynamic>),
      (json['playerList'] as List<dynamic>)
          .map((e) => PlayerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LobbyDtoToJson(LobbyDto instance) => <String, dynamic>{
      'id': instance.id,
      'status': _$LobbyStatusEnumMap[instance.status]!,
      'roundDuration': instance.roundDuration,
      'maxRoundNumber': instance.maxRoundNumber,
      'currentRound': instance.currentRound,
      'round': instance.round,
      'currentBlackCard': instance.currentBlackCard,
      'playerList': instance.playerList,
    };

const _$LobbyStatusEnumMap = {
  LobbyStatus.open: 'open',
  LobbyStatus.initial: 'initial',
  LobbyStatus.play: 'play',
  LobbyStatus.voting: 'voting',
  LobbyStatus.prep: 'prep',
  LobbyStatus.closed: 'closed',
};
