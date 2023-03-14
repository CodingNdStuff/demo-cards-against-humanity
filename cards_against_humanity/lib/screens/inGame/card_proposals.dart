import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/models/white_card.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/black_card_item.dart';
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
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Winner is being choosen . . .",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 4 / 3,
              ),
              children: [
                ...proposals.map((prop) => CardProposalsItem(
                      playerId: prop["playerId"],
                      cardList: prop["playedCards"],
                      currentBlackCard: lobby.currentBlackCard!,
                      isMyTurn: isMyTurn,
                      handleVote: handleVote,
                    )),
              ],
            ),
          ),
          // SingleChildScrollView(
          //     child: Row(
          //   children: [
          //     ...proposals
          //         .map((prop) => CardProposalsItem(
          //               playerId: prop["playerId"],
          //               cardList: prop["playedCards"],
          //               currentBlackCard: lobby.currentBlackCard!,
          //               isMyTurn: isMyTurn,
          //               handleVote: handleVote,
          //             ))
          //         .toList(),
          //   ],
          // )),
        ],
      ),
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
    return SizedBox(
      height: 300,
      width: 400,
      child: BlackCardItem(
        displayText: TextParser.parse(currentBlackCard.text, cardList),
        action: ElevatedButton(
          onPressed: isMyTurn ? () => handleVote(playerId) : null,
          child: const Text("Vote this one!"),
        ),
      ),
    );
  }
}
