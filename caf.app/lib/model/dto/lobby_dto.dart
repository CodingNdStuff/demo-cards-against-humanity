import 'package:cards_against_humanity/model/dto/black_card_dto.dart';
import 'package:cards_against_humanity/model/dto/round_dto.dart';
import 'package:cards_against_humanity/model/lobby.dart';
import 'package:json_annotation/json_annotation.dart';
import 'player_dto.dart';

part 'lobby_dto.g.dart';

@JsonSerializable()
class LobbyDto {
  LobbyDto(
    this.id,
    this.status,
    this.roundDuration,
    this.maxRoundNumber,
    this.currentRound,
    this.round,
    this.currentBlackCard,
    this.playerList,
  );

  String id;
  LobbyStatus status;
  int roundDuration;
  int maxRoundNumber;
  int currentRound;
  RoundDto? round;
  BlackCardDto? currentBlackCard;
  List<PlayerDto> playerList;

  factory LobbyDto.fromJson(Map<String, dynamic> json) =>
      _$LobbyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyDtoToJson(this);
}
