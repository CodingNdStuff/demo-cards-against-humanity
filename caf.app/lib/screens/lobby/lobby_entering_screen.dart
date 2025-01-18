import 'package:cards_against_humanity/screens/inGame/game_screen.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LobbyEnteringScreen extends StatefulWidget {
  static const routeName = "/lobby/entering";
  const LobbyEnteringScreen({super.key});

  @override
  State<LobbyEnteringScreen> createState() => _LobbyEnteringScreenState();
}

class _LobbyEnteringScreenState extends State<LobbyEnteringScreen>
    with WidgetsBindingObserver {
  final _lobbyCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _lobbyCode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayouts.mainLayout([
      Column(
        children: [
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
          ElevatedButton(
              onPressed: () => _handleEnterLobby(), child: const Text("Join"))
        ],
      )
    ], context);
  }

  void _handleEnterLobby() async {
    final vm = Provider.of<LobbyViewModel>(context, listen: false);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    bool isSuccess =
        await vm.joinLobby(_lobbyCode.text.trim(), args["nickname"]!);
    if (isSuccess) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        // if successful, navigate to lobby
        GameScreen.routeName,
        (route) => false,
      );
    }
  }
}
