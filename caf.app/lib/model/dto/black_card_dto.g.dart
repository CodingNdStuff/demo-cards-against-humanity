// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'black_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlackCardDto _$BlackCardDtoFromJson(Map<String, dynamic> json) => BlackCardDto(
      (json['id'] as num).toInt(),
      json['text'] as String,
      (json['numberOfBlanks'] as num).toInt(),
    );

Map<String, dynamic> _$BlackCardDtoToJson(BlackCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'numberOfBlanks': instance.numberOfBlanks,
    };
