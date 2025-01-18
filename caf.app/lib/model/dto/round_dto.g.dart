// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoundDto _$RoundDtoFromJson(Map<String, dynamic> json) => RoundDto(
      json['currentBlackCard'] == null
          ? null
          : BlackCardDto.fromJson(
              json['currentBlackCard'] as Map<String, dynamic>),
      (json['playedCards'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => WhiteCardDto.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      json['winnerNickname'] as String?,
      (json['winnerCardTexts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoundDtoToJson(RoundDto instance) => <String, dynamic>{
      'currentBlackCard': instance.currentBlackCard,
      'playedCards': instance.playedCards,
      'winnerNickname': instance.winnerNickname,
      'winnerCardTexts': instance.winnerCardTexts,
    };
