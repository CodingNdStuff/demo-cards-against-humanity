// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerDto _$PlayerDtoFromJson(Map<String, dynamic> json) => PlayerDto(
      json['nickname'] as String,
      json['ready'] as bool,
      json['myTurn'] as bool,
      (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerDtoToJson(PlayerDto instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'ready': instance.ready,
      'myTurn': instance.myTurn,
      'score': instance.score,
    };
