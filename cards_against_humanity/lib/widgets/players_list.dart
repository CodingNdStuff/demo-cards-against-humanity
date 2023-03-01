import 'package:cards_against_humanity/widgets/players_list_item.dart';
import 'package:flutter/material.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key, required this.players});
  final Map<String, dynamic> players;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...players.entries
                .map((e) => SizedBox(
                      width: (MediaQuery.of(context).size.width) * 0.25,
                      child: PlayerListItem(
                          playerName: e.key, playerScore: e.value["score"]),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
