import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostGameScreen extends StatelessWidget {
  static const routeName = "/postgame";
  const PostGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providedData = Provider.of<MqttClientWrapper>(context);
    // final userId = Provider.of<User>(context, listen: false).playerData.id;
    final lobby = providedData.lobby!;
    final players = lobby.players;
    players.sort(((a, b) => b.score - a.score));
    final numberOfPlayers = players.length;

    void _handleNavigateHome() {
      providedData.disconnect();
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 32),
        child: Center(
            child: Column(
          children: [
            Text(
              "Congrats",
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                // decoration: BoxDecoration(color: Colors.amber),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          AutoSizeText(
                              maxLines: 1,
                              players[1].nickname,
                              softWrap: false,
                              style: Theme.of(context).textTheme.headline1),
                          PodiumItem(
                            heightFactor: 0.6,
                            score: players[1].score,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          AutoSizeText(
                              maxLines: 1,
                              players[0].nickname,
                              softWrap: false,
                              style: Theme.of(context).textTheme.headline1),
                          PodiumItem(
                            heightFactor: 1,
                            score: players[0].score,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          AutoSizeText(
                              maxLines: 1,
                              wrapWords: false,
                              players[2].nickname,
                              softWrap: false,
                              style: Theme.of(context).textTheme.headline1),
                          PodiumItem(
                            heightFactor: 0.4,
                            score: players[2].score,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _handleNavigateHome(),
              child: const Text("Back to home"),
            ),
          ],
        )),
      ),
    );
  }
}

class PodiumItem extends StatelessWidget {
  const PodiumItem({
    super.key,
    required this.heightFactor,
    required this.score,
  });
  final double heightFactor;
  final int score;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4 * heightFactor,
            margin: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: const BoxDecoration(color: Colors.blue, boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(
                  2.0,
                  2.0,
                ),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              )
            ]),
          ),
          Text(
            "$score pts",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(color: Colors.white70, fontSize: 32),
          ),
        ],
      ),
    );
  }
}

class PostGamePlayer extends StatelessWidget {
  const PostGamePlayer({
    super.key,
    required this.nickname,
    required this.score,
    required this.scaleFactor,
    required this.numberOfPlayers,
  });
  final String nickname;
  final int score;
  final double scaleFactor;
  final int numberOfPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.amber),
      width: MediaQuery.of(context).size.width * 0.7 * scaleFactor,
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(nickname),
        subtitle: Text("$score pts"),
      ),
    );
  }
}
