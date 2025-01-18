import 'package:cards_against_humanity/model/dto/black_card_dto.dart';
import 'package:cards_against_humanity/model/dto/white_card_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'round_dto.g.dart';

@JsonSerializable()
class RoundDto {
  RoundDto(
    this.currentBlackCard,
    this.playedCards,
    this.winnerNickname,
    this.winnerCardTexts,
  );

  BlackCardDto? currentBlackCard;
  Map<String, List<WhiteCardDto>>? playedCards;
  String? winnerNickname;
  List<String>? winnerCardTexts;

  factory RoundDto.fromJson(Map<String, dynamic> json) => _$RoundDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RoundDtoToJson(this);
}
