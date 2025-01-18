import 'package:auto_size_text/auto_size_text.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostGameScreen extends StatelessWidget {
  static const routeName = "/postgame";
  const PostGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LobbyViewModel>(context);
    final players = vm.playerList;
    players.sort(((a, b) => b.score - a.score));
    final numberOfPlayers = players.length;
    final maxScore = players[0].score;
    void handleNavigateHome() {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      //Provider.of<ApiChangeNotifier>(context, listen: false).reset(); TODO
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 32),
        child: Center(
            child: Column(
          children: [
            Text(
              "Congrats",
              style: Theme.of(context).textTheme.headlineLarge,
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
                      child: numberOfPlayers < 2
                          ? Container()
                          : ComposedPodium(
                              nickname: players[1].nickname,
                              score: players[1].score,
                              maxScore: maxScore,
                            ),
                    ),
                    Expanded(
                      child: ComposedPodium(
                        nickname: players[0].nickname,
                        score: players[0].score,
                        maxScore: maxScore,
                      ),
                    ),
                    Expanded(
                      child: numberOfPlayers < 3
                          ? Container()
                          : ComposedPodium(
                              nickname: players[2].nickname,
                              score: players[2].score,
                              maxScore: maxScore,
                            ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => handleNavigateHome(),
              child: const Text("Back to home"),
            ),
          ],
        )),
      ),
    );
  }
}

class ComposedPodium extends StatelessWidget {
  const ComposedPodium({
    super.key,
    required this.nickname,
    required this.score,
    required this.maxScore,
  });
  final String nickname;
  final int score;
  final int maxScore;

  @override
  Widget build(BuildContext context) {
    final heightFactor = score / maxScore;
    return Column(
      children: [
        AutoSizeText(
            maxLines: 1,
            nickname,
            softWrap: false,
            style: Theme.of(context).textTheme.headlineLarge),
        PodiumElement(
          heightFactor: heightFactor,
          score: score,
        ),
      ],
    );
  }
}

class PodiumElement extends StatelessWidget {
  const PodiumElement({
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
            height: MediaQuery.of(context).size.height *
                0.4 *
                (heightFactor > 0 ? heightFactor : 1),
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
                .headlineLarge
                ?.copyWith(color: Colors.white70, fontSize: 32),
          ),
        ],
      ),
    );
  }
}
