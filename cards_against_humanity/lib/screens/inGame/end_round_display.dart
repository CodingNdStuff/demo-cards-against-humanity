import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/player.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/models/white_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndRoundDisplay extends StatelessWidget {
  const EndRoundDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<MqttClientWrapper>(context);
    final userId = Provider.of<User>(context, listen: false).playerData.id;
    final lobby = providedData.lobby!;
    final proposals = providedData.proposals!;

    void handleReady() {
      final notifier = Provider.of<ApiChangeNotifier>(context, listen: false);
      notifier.reset();
      notifier.setPlayerReady(lobby.id, userId);
    }

    String parseText() {
      final Player winner = lobby.whoOwnsToken();
      final List<WhiteCard> winningProposal = proposals
          .firstWhere((p) => p["playerId"] == winner.id)["playedCards"];
      String parsed = lobby.currentBlackCard!.text;
      winningProposal.forEach((card) {
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

    return Container(
      height: 300,
      width: 400,
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("WINNER IS"),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.65,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
            padding: const EdgeInsets.all(15),
            color: Colors.black,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: AutoSizeText(
                maxLines: 5,
                wrapWords: false,
                parseText(),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
