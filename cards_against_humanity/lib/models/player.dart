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
}
