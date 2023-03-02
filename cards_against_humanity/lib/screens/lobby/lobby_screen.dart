import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/lobby.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = "/lobby";
  const LobbyScreen({super.key});
  static const _lobbyCode = "123981";

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  bool isReady = false;
  bool _isInitialized = false;
  Lobby? lobbyData;
  final Map<String, dynamic> _players = {
    "player1": {
      "score": 300,
      "ready": false,
    },
    "player2": {
      "score": 500,
      "ready": false,
    },
    "player-123456789": {
      "score": 900,
      "ready": false,
    },
    "player-136789": {
      "score": 200,
      "ready": true,
    },
    "player3": {
      "score": 500,
      "ready": false,
    },
    "player-122456789": {
      "score": 900,
      "ready": false,
    },
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<MqttClientWrapper>(context).connect("4jjjnpe6");

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String lobbyId = ModalRoute.of(context)?.settings.arguments as String;

    lobbyData = Provider.of<MqttClientWrapper>(context).lobby;
    print(lobbyData?.players[0].nickname);
    return CustomLayouts.mainLayout([
      Text("Lobby code: ${lobbyData?.id}"),
      Text("duration: ${lobbyData?.roundDuration}"),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.7,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
        onPressed: isReady ? null : _handleReady,
        child: const Text("I'm ready!"),
      ),
    ], context);
  }

  void _handleReady() {
    setState(() {
      isReady = true;
      _players.update(
          "player1",
          (value) => {
                "score": 300,
                "ready": true,
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
