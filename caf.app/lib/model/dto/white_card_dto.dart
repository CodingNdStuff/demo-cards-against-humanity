import 'package:json_annotation/json_annotation.dart';

part 'white_card_dto.g.dart';

@JsonSerializable()
class WhiteCardDto {
  WhiteCardDto(this.id, this.text);

  int id;
  String text;

  factory WhiteCardDto.fromJson(Map<String, dynamic> json) =>
      _$WhiteCardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WhiteCardDtoToJson(this);
}
