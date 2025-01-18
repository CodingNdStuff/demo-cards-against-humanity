import 'package:cards_against_humanity/model/lobby.dart';
import 'package:flutter/material.dart';

class PlayerListItem extends StatelessWidget {
  const PlayerListItem({
    super.key,
    required this.playerName,
    required this.playerScore,
    required this.isReady,
    required this.isMyTurn,
    required this.phase,
  });
  final String playerName;
  final int playerScore;
  final bool isReady;
  final bool isMyTurn;
  final LobbyStatus phase;
  final avatar = const Icon(Icons.person);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: avatar,
        ),
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            playerName,
          ),
        ),
        textColor: Colors.black,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${playerScore}pts"),
            FittedBox(
              child: displayStatus(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayStatus(BuildContext context) {
    //todo: work in progress
    if (phase == LobbyStatus.play) {
      if (isMyTurn) {
        return Text(
          "Holds the black card",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
      if (isReady) {
        return Text(
          "Ready",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }
      return Text(
        "Is choosing a card",
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }
    return const Text(" ");
  }
}
