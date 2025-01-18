import 'package:cards_against_humanity/model/user.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_creation_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_entering_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _nicknameController.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bool isKeyboardShowing = MediaQuery.of(context).viewInsets.right > 0;
    if (!isKeyboardShowing) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO save in memory user.playerData.nickname;
    return Scaffold(
        body: Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Cards \nAgainst \nHumanity",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                  textAlign: TextAlign.center,
                  maxLength: 16,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    counterText: "",
                  ),
                  controller: _nicknameController,
                  onChanged: (value) =>
                      null // user.changeNickname(value.trim()),
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleCreateLobby(_nicknameController.text),
                  child: const Text("Create lobby"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () => _handleJoinLobby(_nicknameController.text),
                  child: const Text("Join lobby"),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void _handleCreateLobby(String nickname) {
    Navigator.of(context).pushNamed(LobbyCreationScreen.routeName,
        arguments: {"nickname": nickname});
  }

  void _handleJoinLobby(String nickname) {
    Navigator.of(context).pushNamed(LobbyEnteringScreen.routeName,
        arguments: {"nickname": nickname});
  }
}
