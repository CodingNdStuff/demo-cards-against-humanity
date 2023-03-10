import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCard =
        Provider.of<MqttClientWrapper>(context).lobby!.currentBlackCard;

    String parseText() {
      if (currentCard == null) return "";
      String parsed = currentCard.text;
      print(currentCard.placedCards.entries);
      currentCard.placedCards.entries.toList()
        ..sort((a, b) => a.key.compareTo(b
            .key)) // once they are in order we can use a replace method (which works on first occurrence);
        ..forEach((entry) {
          // Find the position of the underscore at the key index
          int underscorePos = parsed.indexOf("_", entry.key);

          // Replace the "_" at the position with the value from the entry
          parsed = parsed.replaceRange(
              underscorePos,
              underscorePos + 1,
              entry.value.text
                  .replaceAll(".", "")); // occasionally they might have dots.
        });
      return parsed.replaceAll("_", "_______");
    }

    void _resetPlacedCards() {
      if (currentCard == null) return;
      Provider.of<MqttClientWrapper>(context, listen: false).takeCardsBack();
    }

    return GestureDetector(
      onDoubleTap: () => _resetPlacedCards(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.65,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
        padding: const EdgeInsets.all(15),
        color: Colors.black,
        child: Center(
          child: AutoSizeText(
            maxLines: 5,
            wrapWords: false,
            parseText(),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
