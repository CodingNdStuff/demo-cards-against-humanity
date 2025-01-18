import 'package:cards_against_humanity/model/black_card.dart';
import 'package:cards_against_humanity/model/player.dart';

// ignore: camel_case_types
enum LobbyStatus { open, initial, play, voting, prep, closed }

class Lobby {
  String id;
  LobbyStatus phase;
  int roundDuration;
  int maxRoundNumber;
  List<Player> players = [];
  int? currentRound;
  BlackCard? currentBlackCard;
  Lobby({
    required this.id,
    required this.roundDuration,
    required this.maxRoundNumber,
    required this.currentRound,
    required this.players,
    required this.phase,
  });

  Lobby.open(
      {required this.id,
      required this.roundDuration,
      required this.maxRoundNumber,
      required this.players,
      this.phase = LobbyStatus.open});

  bool isMyTurn(String userId) {
    return players.firstWhere((p) => p.id == userId).isMyTurn;
  }

  Player? whoOwnsToken() {
    Player? player;
    for (var p in players) {
      if (p.isMyTurn) {
        player = p;
      }
    }
    return player;
  }
}
