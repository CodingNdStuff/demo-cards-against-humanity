import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({super.key});

  void _handleConfirmPLayCards(BuildContext context) {
    final playerData = Provider.of<User>(context, listen: false).playerData;
    final lobbyData =
        Provider.of<MqttClientWrapper>(context, listen: false).lobby!;
    Provider.of<ApiChangeNotifier>(context, listen: false).playCard(
        lobbyData.id, playerData.id, lobbyData.currentBlackCard!.placedCards);
  }

  @override
  Widget build(BuildContext context) {
    final currentCard =
        Provider.of<MqttClientWrapper>(context).lobby!.currentBlackCard;
    bool displayButton =
        currentCard?.placedCards.length == currentCard?.numberOfBlanks;
    String parseText() {
      if (currentCard == null) return "";
      String parsed = currentCard.text;
      currentCard.placedCards.forEach((card) {
        // Find the position of the underscore
        int underscorePos = parsed.indexOf("_");

        // Replace the "_" at the position with the value from the entry
        parsed = parsed.replaceRange(
            underscorePos,
            underscorePos + 1,
            card.text
                .replaceAll(".", "")); // occasionally they might have dots.
      });
      return parsed.replaceAll("_", "_______");
    }

    void resetPlacedCards() {
      if (currentCard == null) return;
      Provider.of<MqttClientWrapper>(context, listen: false).takeCardsBack();
    }

    return GestureDetector(
      onDoubleTap: () => resetPlacedCards(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.65,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
        padding: const EdgeInsets.all(15),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: AutoSizeText(
                maxLines: 5,
                wrapWords: false,
                parseText(),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            ElevatedButton(
              onPressed:
                  displayButton ? () => _handleConfirmPLayCards(context) : null,
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
