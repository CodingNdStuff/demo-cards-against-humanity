import 'package:cards_against_humanity/model/lobby.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/screens/inGame/card_proposals.dart';
import 'package:cards_against_humanity/screens/inGame/end_round_display.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/hand.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/table.dart';
import 'package:cards_against_humanity/screens/inGame/game_components/players_list.dart';
import 'package:cards_against_humanity/screens/inGame/post_game_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  static const routeName = "/game";
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final vm = Provider.of<LobbyViewModel>(context);
      try {
        vm.id;
      } catch (e) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (_) => true,
        );
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LobbyViewModel>(context);
    switch (vm.status) {
      case LobbyStatus.open:
        return const LobbyScreen();
      case LobbyStatus.play:
        return const OngoingPlayLobby();
      case LobbyStatus.voting:
        return const OngoingVotingLobby();
      case LobbyStatus.prep:
        return const OngoingRoundEndLobby();
      case LobbyStatus.closed:
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
    final vm = Provider.of<LobbyViewModel>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.surface,
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
              child: Text(
                "Round: ${vm.round} / ${vm.maxRoundNumber}",
                style: const TextStyle(color: Colors.black54),
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
        color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.surface,
        child: const PostGameScreen(),
      ),
    );
  }
}
