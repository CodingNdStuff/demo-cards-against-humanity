// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_card_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayCardRequest _$PlayCardRequestFromJson(Map<String, dynamic> json) =>
    PlayCardRequest(
      (json['cardIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PlayCardRequestToJson(PlayCardRequest instance) =>
    <String, dynamic>{
      'cardIds': instance.cardIds,
    };
