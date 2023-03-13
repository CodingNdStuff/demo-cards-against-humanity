import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/models/white_card.dart';
import 'package:cards_against_humanity/utils/text_parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardProposals extends StatelessWidget {
  const CardProposals({super.key});

  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<MqttClientWrapper>(context);
    final userId = Provider.of<User>(context, listen: false).playerData.id;
    final lobby = providedData.lobby!;
    final proposals = providedData.proposals!;
    final isMyTurn = lobby.isMyTurn(userId);
    void handleVote(String votedPlayerId) {
      final notifier = Provider.of<ApiChangeNotifier>(context, listen: false);
      notifier.reset();
      notifier.voteWinner(lobby.id, userId, votedPlayerId);
    }

    return Container(
      alignment: Alignment.center,
      color: Colors.amber,
      child: SingleChildScrollView(
          child: Row(
        children: [
          ...proposals
              .map((prop) => CardProposalsItem(
                    playerId: prop["playerId"],
                    cardList: prop["playedCards"],
                    currentBlackCard: lobby.currentBlackCard!,
                    isMyTurn: isMyTurn,
                    handleVote: handleVote,
                  ))
              .toList(),
        ],
      )),
    );
  }
}

class CardProposalsItem extends StatelessWidget {
  const CardProposalsItem({
    super.key,
    required this.playerId,
    required this.cardList,
    required this.currentBlackCard,
    required this.isMyTurn,
    required this.handleVote,
  });
  final String playerId;
  final List<WhiteCard> cardList;
  final BlackCard currentBlackCard;
  final bool isMyTurn;
  final Function handleVote;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 400,
      color: Colors.blueAccent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.65,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
        padding: const EdgeInsets.all(15),
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: AutoSizeText(
                maxLines: 5,
                wrapWords: false,
                TextParser.parse(currentBlackCard.text, cardList),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            ElevatedButton(
              onPressed: isMyTurn ? () => handleVote(playerId) : null,
              child: const Text("Vote this one!"),
            ),
          ],
        ),
      ),
    );
  }
}
