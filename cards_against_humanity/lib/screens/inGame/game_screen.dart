import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/screens/inGame/hand.dart';
import 'package:cards_against_humanity/screens/inGame/table.dart';
import 'package:cards_against_humanity/screens/inGame/players_list.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  static const routeName = "/game";
  const GameScreen({super.key});
  static Map<String, dynamic> players = {
    "player-1": {
      "score": 200,
    },
    "player-2": {
      "score": 200,
    },
    "player-3": {
      "score": 200,
    },
    "player-4": {
      "score": 200,
    },
    "player-5": {
      "score": 200,
    },
    "player-6": {
      "score": 200,
    },
  };

  static BlackCard currentCard = BlackCard(
      1, "News - Naufragio a Napoli, la reazione della Meloni: _ .", 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          // alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              right: 0,
              child: PlayersList(
                players: players,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: TableWidget(currentCard: currentCard),
            ),
            Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.width * 0.15,
              child: const Hand(),
            ),
          ],
        ),
      ),
    );
  }
}
