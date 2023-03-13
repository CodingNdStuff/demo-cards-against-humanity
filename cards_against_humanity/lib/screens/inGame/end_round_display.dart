import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/player.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/models/white_card.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/black_card_item.dart';
import 'package:cards_against_humanity/utils/text_parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndRoundDisplay extends StatefulWidget {
  const EndRoundDisplay({super.key});

  @override
  State<EndRoundDisplay> createState() => _EndRoundDisplayState();
}

class _EndRoundDisplayState extends State<EndRoundDisplay> {
  bool _isReady = false;
  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<MqttClientWrapper>(context);
    final userId = Provider.of<User>(context, listen: false).playerData.id;
    final lobby = providedData.lobby!;
    final proposals = providedData.proposals!;

    void handleReady() {
      final notifier = Provider.of<ApiChangeNotifier>(context, listen: false);

      notifier.setPlayerReady(lobby.id, userId);
      notifier.reset();
      setState(() {
        _isReady = true;
      });
    }

    final Player winner = lobby.whoOwnsToken();
    final List<WhiteCard> winningProposal =
        proposals.firstWhere((p) => p["playerId"] == winner.id)["playedCards"];
    return Container(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      height: 300,
      width: 400,
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "WINNER IS",
            style: Theme.of(context).textTheme.headline1,
          ),
          BlackCardItem(
            displayText: TextParser.parse(
              lobby.currentBlackCard?.text ?? "",
              winningProposal,
            ),
            action: _isReady
                ? const ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black)),
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
