// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:cards_against_humanity/screens/inGame/game_components/black_card_item.dart';
import 'package:cards_against_humanity/utils/text_parser.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  void _handleConfirmPlayCards() {
    final vm = Provider.of<LobbyViewModel>(context, listen: false).playCards();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LobbyViewModel>(context);
    bool displayButton = vm.placedCards.length ==
        vm.round?.currentBlackCard?.numberOfBlanks;

    void resetPlacedCards() {
      vm.resetPlacedCards();
    }

    return GestureDetector(
      onDoubleTap: () => resetPlacedCards(),
      child: BlackCardItem(
        //render a black card, as an action we have a conditional button
        displayText: TextParser.parse(
          vm.round?.currentBlackCard?.text ?? "",
          vm.placedCards,
        ),
        action: vm.user.isReady
            ? const ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.black)),
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
