import 'package:cards_against_humanity/models/white_card.dart';

class BlackCard {
  final int id;
  final String text; // "La meloni ha concesso il diritto al _ ."
  final int numberOfBlanks; // 1
  List<WhiteCard> placedCards = [];
  BlackCard(this.id, this.text, this.numberOfBlanks);
}
