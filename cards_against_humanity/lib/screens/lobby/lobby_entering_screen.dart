import 'package:cards_against_humanity/helpers/http_helper.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:cards_against_humanity/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyEnteringScreen extends StatefulWidget {
  static const routeName = "/lobby-entering";
  const LobbyEnteringScreen({super.key});

  @override
  State<LobbyEnteringScreen> createState() => _LobbyEnteringScreenState();
}

class _LobbyEnteringScreenState extends State<LobbyEnteringScreen> {
  final _lobbyCode = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _lobbyCode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayouts.mainLayout([
      _isLoading
          ? const CircularProgressIndicator()
          : SizedBox(
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
      ElevatedButton(
          onPressed: _isLoading ? null : () => _handleEnterLobby(context),
          child: const Text("Join")),
    ], context);
  }

  void _handleEnterLobby(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final playerData = Provider.of<User>(context, listen: false).playerData;
    try {
      await API
          .enterLobby(_lobbyCode.text, playerData.id, playerData.nickname)
          .then((success) {
        if (!success) {
          showDialog(
            context: context,
            builder: (context) => const ErrorDialog(
              title: "Invalid code",
              content: "The entered code does not correspond to an open lobby.",
            ),
          ).then((value) => setState(() {
                _isLoading = false;
              }));
          return;
        }
        Navigator.of(context).pushNamedAndRemoveUntil(
            LobbyScreen.routeName, ((route) => false),
            arguments: _lobbyCode.text);
      });
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
            title: "Connection error",
            content: "Looks like the server is not online."),
      ).then((value) => setState(() {
            _isLoading = false;
          }));
    }
  }
}
