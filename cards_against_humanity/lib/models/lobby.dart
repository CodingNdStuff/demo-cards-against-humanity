import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/player.dart';

class Lobby {
  String id;
  int roundDuration;
  int maxRoundNumber;
  List<Player> players = [];
  int currentRound;
  BlackCard? currentBlackCard;
  Lobby(
      {required this.id,
      required this.roundDuration,
      required this.maxRoundNumber,
      this.currentBlackCard,
      required this.currentRound,
      required this.players});
}
