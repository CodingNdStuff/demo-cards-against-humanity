import 'package:flutter/material.dart';

class PlayerListItem extends StatelessWidget {
  const PlayerListItem(
      {super.key, required this.playerName, required this.playerScore});
  final String playerName;
  final int playerScore;
  final avatar = const Icon(Icons.person);
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      subtitle: Text("${playerScore}pt"),
    );
  }
}
