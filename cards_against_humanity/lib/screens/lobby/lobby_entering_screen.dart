import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';

class LobbyEnteringScreen extends StatefulWidget {
  static const routeName = "/lobby-entering";
  const LobbyEnteringScreen({super.key});

  @override
  State<LobbyEnteringScreen> createState() => _LobbyEnteringScreenState();
}

class _LobbyEnteringScreenState extends State<LobbyEnteringScreen> {
  final _lobbyCode = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _lobbyCode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayouts.mainLayout([
      SizedBox(
        width: 300,
        child: TextFormField(
          controller: _lobbyCode,
          maxLength: 20,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            label: Text("Lobby code"),
            counterText: "",
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      ElevatedButton(onPressed: _handleEnterLobby, child: const Text("Join")),
    ], context);
  }

  void _handleEnterLobby() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(LobbyScreen.routeName, ((route) => false));
  }
}
