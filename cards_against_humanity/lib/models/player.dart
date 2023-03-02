class Player {
  final String id;
  final String nickname;
  int score = 0;
  bool isMyTurn = false;
  bool isReady = false;

  Player(this.id, this.nickname, this.isReady, this.score, this.isMyTurn);
  Player.inLobby(this.id, this.nickname, this.isReady);
}
