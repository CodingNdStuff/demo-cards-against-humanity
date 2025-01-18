// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'white_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhiteCardDto _$WhiteCardDtoFromJson(Map<String, dynamic> json) => WhiteCardDto(
      (json['id'] as num).toInt(),
      json['text'] as String,
    );

Map<String, dynamic> _$WhiteCardDtoToJson(WhiteCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
    };
