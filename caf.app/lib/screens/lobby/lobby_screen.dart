import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:cards_against_humanity/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = "/lobby";
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<LobbyViewModel>(context);
    if (vm.isLoading) {
      return CustomLayouts.mainLayout([
        const CircularProgressIndicator(),
      ], context);
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          // TODO: allow people to join / leave and handle destroy lobby
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.arrow_back),
          // ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.surface),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lobby code: ${vm.id}",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          childAspectRatio: 4 / 2,
                        ),
                        children: [
                          ...vm.playerList.map(
                            (e) => PlayerInLobbyListItem(
                                playerName: e.nickname, ready: e.isReady),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: vm.user.isReady
                          ? null
                          : () => _handleReady(vm.playerList.length),
                      child: const Text("I'm ready!"),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Number of rounds: ${vm.maxRoundNumber}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const Text(
                    "Minimum players: 2",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    "Round duration: ${vm.roundDuration}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  void _handleReady(int playersInLobby) async {
    if (playersInLobby < 2) {
      return showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
            title: "You fool", content: "Need at least 2 players to play!"),
      );
    }
    Provider.of<LobbyViewModel>(context, listen: false).setPlayerReady();
  }
}

class PlayerInLobbyListItem extends StatelessWidget {
  const PlayerInLobbyListItem(
      {super.key, required this.playerName, required this.ready});
  final String playerName;
  final bool ready;
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
      subtitle: ready
          ? Text(
              "Ready",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Text(
              "Not ready",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
    );
  }
}
