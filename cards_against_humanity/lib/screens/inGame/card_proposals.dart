import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/white_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardProposals extends StatelessWidget {
  const CardProposals({super.key});

  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<MqttClientWrapper>(context);
    final lobby = providedData.lobby!;
    final proposals = providedData.proposals!;
    return Container(
      alignment: Alignment.center,
      color: Colors.amber,
      child: SingleChildScrollView(
          child: Row(
        children: [
          ...proposals
              .map((prop) => ProposalCard(
                    playerId: prop["playerId"],
                    cardList: prop["playedCards"],
                    currentBlackCard: lobby.currentBlackCard!,
                  ))
              .toList(),
        ],
      )),
    );
  }
}

class ProposalCard extends StatelessWidget {
  const ProposalCard({
    super.key,
    required this.playerId,
    required this.cardList,
    required this.currentBlackCard,
  });
  final String playerId;
  final List<WhiteCard> cardList;
  final BlackCard currentBlackCard;

  String parseText() {
    String parsed = currentBlackCard.text;
    cardList.forEach((card) {
      // Find the position of the underscore
      int underscorePos = parsed.indexOf("_");

      // Replace the "_" at the position with the value from the entry
      parsed = parsed.replaceRange(underscorePos, underscorePos + 1,
          card.text.replaceAll(".", "")); // occasionally they might have dots.
    });
    return parsed.replaceAll("_", "_______");
  }

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
    );
  }
}
