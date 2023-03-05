import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/player.dart';

class Lobby {
  String id;
  bool open;
  int roundDuration;
  int maxRoundNumber;
  List<Player> players = [];
  int? currentRound;
  BlackCard? currentBlackCard;
  Lobby(
      {required this.id,
      required this.roundDuration,
      required this.maxRoundNumber,
      this.currentBlackCard,
      required this.currentRound,
      required this.players,
      this.open = false});

  Lobby.open(
      {required this.id,
      required this.roundDuration,
      required this.maxRoundNumber,
      required this.players,
      this.open = true});
}
