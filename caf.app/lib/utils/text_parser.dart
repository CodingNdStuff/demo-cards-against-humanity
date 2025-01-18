import 'package:cards_against_humanity/model/white_card.dart';

abstract class TextParser {
  static String parse(String text, List<WhiteCard> placedCards) {
    if (placedCards.isEmpty) return text.replaceAll("_", "_______");
    String parsed = text;
    for (var card in placedCards) {
      // Find the position of the underscore
      int underscorePos = parsed.indexOf("_");

      // Replace the "_" at the position with the value from the entry
      parsed = parsed.replaceRange(
        underscorePos,
        underscorePos + 1,
        card.text.replaceAll(".", ""),
      );
    }
    return parsed.replaceAll(
        "_", "_______"); // occasionally they might have dots.;
  }
}
