import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/lobby.dart';
import 'package:cards_against_humanity/screens/inGame/card_proposals.dart';
import 'package:cards_against_humanity/screens/inGame/end_round_display.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/hand.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/table.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/players_list.dart';
import 'package:cards_against_humanity/screens/inGame/post_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  static const routeName = "/game";
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phase = Provider.of<MqttClientWrapper>(context).lobby?.phase;
    switch (phase) {
      case status.play:
        return const OngoingPlayLobby();
      case status.voting:
        return const OngoingVotingLobby();
      case status.prep:
        return const OngoingRoundEndLobby();
      case status.closed:
        return const ClosedLobby();
      default:
        return Container();
    }
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
            Positioned(
              bottom: 10,
              right: 10,
              child: Consumer<MqttClientWrapper>(
                builder: (_, notifier, __) => Text(
                  "Round: ${notifier.lobby!.currentRound! + 1} / ${notifier.lobby?.maxRoundNumber}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
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

class OngoingRoundEndLobby extends StatelessWidget {
  const OngoingRoundEndLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.background,
        child: const EndRoundDisplay(),
      ),
    );
  }
}

class ClosedLobby extends StatelessWidget {
  const ClosedLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.background,
        child: const PostGameScreen(),
      ),
    );
  }
}
