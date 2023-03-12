import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/lobby.dart';
import 'package:cards_against_humanity/screens/inGame/card_proposals.dart';
import 'package:cards_against_humanity/screens/inGame/hand.dart';
import 'package:cards_against_humanity/screens/inGame/table.dart';
import 'package:cards_against_humanity/screens/inGame/players_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  static const routeName = "/game";
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = Provider.of<MqttClientWrapper>(context).lobby?.phase;
    if (phase == status.play) {
      return const OngoingPlayLobby();
    } else if (phase == status.voting) {
      return const OngoingVotingLobby();
    }
    return Container();
  }
}

class OngoingPlayLobby extends StatelessWidget {
  const OngoingPlayLobby({super.key});

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

class OngoingVotingLobby extends StatelessWidget {
  const OngoingVotingLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.background,
        child: const CardProposals(),
      ),
    );
  }
}
