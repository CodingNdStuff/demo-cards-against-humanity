import 'package:cards_against_humanity/screens/inGame/hand.dart';
import 'package:cards_against_humanity/screens/inGame/table.dart';
import 'package:cards_against_humanity/screens/inGame/players_list.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  static const routeName = "/game";
  const GameScreen({super.key});

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
            const Positioned(
              right: 0,
              child: PlayersList(),
            ),
            const Positioned(
              top: 0,
              left: 0,
              child: TableWidget(),
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
