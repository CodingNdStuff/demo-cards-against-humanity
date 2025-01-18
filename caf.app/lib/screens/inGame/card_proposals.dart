import 'package:cards_against_humanity/model/black_card.dart';
import 'package:cards_against_humanity/model/white_card.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/black_card_item.dart';
import 'package:cards_against_humanity/utils/text_parser.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardProposals extends StatelessWidget {
  const CardProposals({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LobbyViewModel>(context);
    Map<String, List<WhiteCard>> proposals = vm.round?.playedCards ?? {};
    final isMyTurn = vm.user.isMyTurn;

    void handleVote(String votedPlayerNickname) {
      vm.voteWinner(votedPlayerNickname);
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Winner is being choosen . . .",
            style: Theme.of(context).textTheme.headlineLarge,
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
                ...proposals.entries.map((prop) => CardProposalsItem(
                      cardList: prop.value,
                      currentBlackCard: vm.round!.currentBlackCard!,
                      isMyTurn: isMyTurn,
                      handleVote: () => handleVote(prop.key),
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
    required this.cardList,
    required this.currentBlackCard,
    required this.isMyTurn,
    required this.handleVote,
  });
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
          onPressed: isMyTurn ? () => handleVote() : null,
          child: const Text("Vote this one!"),
        ),
      ),
    );
  }
}
