class Player {
  final String id;
  String nickname;
  int score = 0;
  bool isMyTurn = false;
  bool isReady = false;

  Player(this.id, this.nickname, this.isReady, this.score, this.isMyTurn);
  Player.inLobby(this.id, this.nickname, this.isReady);
  Player.basic(this.id, this.nickname);
  void setNickname(String newNickname) {
    nickname = newNickname;
  }
}
