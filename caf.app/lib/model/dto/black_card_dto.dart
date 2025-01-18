import 'package:cards_against_humanity/model/black_card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'black_card_dto.g.dart';

@JsonSerializable()
class BlackCardDto {
  BlackCardDto(this.id, this.text, this.numberOfBlanks);

  int id;
  String text;
  int numberOfBlanks;

  BlackCardDto.fromBlackCard(BlackCard card) : 
    id = card.id,
    text = card.text,
    numberOfBlanks = card.numberOfBlanks;

  factory BlackCardDto.fromJson(Map<String, dynamic> json) =>
      _$BlackCardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BlackCardDtoToJson(this);
}
