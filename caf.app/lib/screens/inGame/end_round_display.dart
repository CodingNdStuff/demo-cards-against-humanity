import 'package:cards_against_humanity/model/lobby.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/black_card_item.dart';
import 'package:cards_against_humanity/screens/inGame/post_game_screen.dart';
import 'package:cards_against_humanity/utils/text_parser.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndRoundDisplay extends StatefulWidget {
  const EndRoundDisplay({super.key});

  @override
  State<EndRoundDisplay> createState() => _EndRoundDisplayState();
}

class _EndRoundDisplayState extends State<EndRoundDisplay> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LobbyViewModel>(context);
    final proposals = vm.round?.playedCards ?? {};

    void handleReady() {
      if (vm.status == LobbyStatus.closed) {
        Navigator.of(context).pushReplacementNamed(PostGameScreen.routeName);
        return;
      }
      vm.setPlayerReady();
    }

    final winningProposal = vm.getWinningProposal();

    return Container(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      height: 300,
      width: 400,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "WINNER IS",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          BlackCardItem(
            displayText: TextParser.parse(
              vm.round?.currentBlackCard?.text ?? "",
              winningProposal.value,
            ),
            action: vm.user.isReady
                ? const ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.black)),
                    child: Text(
                      "Waiting for the others . . .",
                      style: TextStyle(color: Colors.amber),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => handleReady(),
                    child: const Text(
                      "I'm ready!",
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
