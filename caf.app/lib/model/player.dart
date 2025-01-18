import 'package:cards_against_humanity/model/dto/player_dto.dart';

class Player {
  final String id;
  String nickname;
  int score = 0;
  bool isMyTurn = false;
  bool isReady = false;

  Player(this.id, this.nickname);
  Player.inLobby(this.id, this.nickname, this.isReady);
  Player.inGame(
      this.id, this.nickname, this.isReady, this.score, this.isMyTurn);
  void setNickname(String newNickname) {
    nickname = newNickname;
  }

  factory Player.fromDto(PlayerDto dto) {
    return Player.inGame("1", dto.nickname, dto.ready, dto.score, dto.myTurn);
  }
}
