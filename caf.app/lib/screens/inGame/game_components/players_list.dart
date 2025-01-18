import 'package:cards_against_humanity/screens/inGame/game_components/players_list_item.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LobbyViewModel>(context);
    final playersList = vm.playerList;
    return Container(
      color: Colors.grey[200],
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...playersList
                .map((p) => SizedBox(
                      width: (MediaQuery.of(context).size.width) * 0.25,
                      child: PlayerListItem(
                          playerName: p.nickname,
                          playerScore: p.score,
                          isReady: p.isReady,
                          isMyTurn: p.isMyTurn,
                          phase: vm.status),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
