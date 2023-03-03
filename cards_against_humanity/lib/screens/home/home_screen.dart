import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_creation_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_entering_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nicknameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    _nicknameController.text = user.playerData.nickname;
    return CustomLayouts.mainLayout([
      Text(
        "Cards \nAgainst \nHumanity",
        style: Theme.of(context).textTheme.headline1,
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
          onChanged: (value) => user.changeNickname(value),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _handleCreateLobby,
            child: const Text("Create lobby"),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            onPressed: _handleJoinLobby,
            child: const Text("Join lobby"),
          ),
        ],
      ),
    ], context);
  }

  void _handleCreateLobby() {
    Navigator.of(context).pushNamed(LobbyCreationScreen.routeName);
  }

  void _handleJoinLobby() {
    Navigator.of(context).pushNamed(LobbyEnteringScreen.routeName);
  }
}
