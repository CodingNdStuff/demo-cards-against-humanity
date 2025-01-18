import 'package:json_annotation/json_annotation.dart';

part 'player_dto.g.dart';

@JsonSerializable()
class PlayerDto {
  PlayerDto(this.nickname, this.ready, this.myTurn, this.score);

  String nickname;
  bool ready;
  bool myTurn;
  int score;

  factory PlayerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDtoToJson(this);
}
