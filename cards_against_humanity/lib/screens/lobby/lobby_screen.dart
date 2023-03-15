import 'package:cards_against_humanity/helpers/http_helper.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/lobby.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/inGame/game_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:cards_against_humanity/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = "/lobby";
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  bool isReady = false;
  bool _isInitialized = false;
  Lobby? lobbyData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      String lobbyId = ModalRoute.of(context)?.settings.arguments as String;
      final playerId = Provider.of<User>(context, listen: false).playerData.id;
      Provider.of<MqttClientWrapper>(context).connect(lobbyId, playerId);
      _isInitialized = true;
    }
  }

  void _handleStartGame() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(GameScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    lobbyData = Provider.of<MqttClientWrapper>(context).lobby;
    if (lobbyData == null) {
      return CustomLayouts.mainLayout([
        const CircularProgressIndicator(),
      ], context);
    } else {
      if (!(lobbyData!.phase == status.open)) _handleStartGame();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          // todo: allow people to join / leave and handle destroy lobby
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
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lobby code: ${lobbyData?.id}",
                      style: Theme.of(context).textTheme.headline1,
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
                          ...?lobbyData?.players.map(
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
                      onPressed: isReady
                          ? null
                          : () => _handleReady(
                                lobbyData?.players.length ?? 0,
                                lobbyData?.id ?? "",
                              ),
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
                    "Number of rounds: ${lobbyData?.maxRoundNumber}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const Text(
                    "Minimum players: 2",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    "Round duration: ${lobbyData?.roundDuration}",
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

  void _handleReady(int playersInLobby, String lobbyId) async {
    if (playersInLobby < 2) {
      return showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
            title: "You fool", content: "Need at least 2 players to play!"),
      );
    }
    final playerData = Provider.of<User>(context, listen: false).playerData;
    await API.setPlayerReady(lobbyId, playerData.id).then((success) {
      if (!success) return;
      setState(() {
        isReady = true;
      });
    });
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
