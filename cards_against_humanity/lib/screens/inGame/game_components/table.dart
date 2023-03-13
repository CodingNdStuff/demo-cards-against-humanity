// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/black_card_item.dart';
import 'package:cards_against_humanity/utils/text_parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  bool _isReady = false;
  void _handleConfirmPlayCards() {
    final notifier = Provider.of<ApiChangeNotifier>(context, listen: false);
    final playerData = Provider.of<User>(context, listen: false).playerData;
    final lobbyData =
        Provider.of<MqttClientWrapper>(context, listen: false).lobby!;

    notifier.reset();
    notifier.playCard(
      lobbyData.id,
      playerData.id,
      lobbyData.currentBlackCard!.placedCards,
    );
    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCard =
        Provider.of<MqttClientWrapper>(context).lobby?.currentBlackCard;
    bool displayButton =
        currentCard?.placedCards.length == currentCard?.numberOfBlanks;

    void resetPlacedCards() {
      if (currentCard == null || _isReady) return;
      Provider.of<MqttClientWrapper>(context, listen: false).takeCardsBack();
    }

    return GestureDetector(
      onDoubleTap: () => resetPlacedCards(),
      child: BlackCardItem(
        //render a black card, as an action we have a conditional button
        displayText:
            TextParser.parse(currentCard?.text ?? "", currentCard?.placedCards),
        action: _isReady
            ? const ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.black)),
                child: Text(
                  "Confirmed",
                  style: TextStyle(color: Colors.amber),
                ),
              )
            : ElevatedButton(
                onPressed:
                    displayButton ? () => _handleConfirmPlayCards() : null,
                child: const Text(
                  "Confirm",
                ),
              ),
      ),
    );
  }
}
