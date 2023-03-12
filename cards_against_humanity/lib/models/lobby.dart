import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/player.dart';

// ignore: camel_case_types
enum status { open, initial, play, voting, prep, closed }

class Lobby {
  String id;
  status phase;
  int roundDuration;
  int maxRoundNumber;
  List<Player> players = [];
  int? currentRound;
  BlackCard? currentBlackCard;
  Lobby({
    required this.id,
    required this.roundDuration,
    required this.maxRoundNumber,
    this.currentBlackCard,
    required this.currentRound,
    required this.players,
    required this.phase,
  });

  Lobby.open(
      {required this.id,
      required this.roundDuration,
      required this.maxRoundNumber,
      required this.players,
      this.phase = status.open});

  bool isMyTurn(String userId) {
    return players.firstWhere((p) => p.id == userId).isMyTurn;
  }

  Player whoOwnsToken() {
    return players.firstWhere((p) => p.isMyTurn);
  }
}
