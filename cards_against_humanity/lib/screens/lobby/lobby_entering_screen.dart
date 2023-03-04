import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:cards_against_humanity/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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

  void _handleStateChange(notifier) {
    // function called when the api of entering a lobby is completed
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (notifier.failure != null) {
        // in case of failure we opena dialog
        final message = notifier.failure
            .message; // we have to store the message because later we invoke reset() which destroys it.
        showDialog(
          context: context,
          builder: (context) =>
              ErrorDialog(title: "Connection error", content: message),
        );
        notifier
            .reset(); // as the user sees the dialog, in the background the situation goes to initial
      } else {
        notifier.reset();
        Navigator.of(context).pushNamedAndRemoveUntil(
            // if successful, navigate to lobby
            LobbyScreen.routeName,
            ((route) => false),
            arguments: _lobbyCode.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayouts.mainLayout([
      Consumer<ApiChangeNotifier>(
        builder: ((_, notifier, __) {
          if (notifier.state == NotifierState.initial) {
            // conditional display of content based on state, initially a textfield and a button
            return Column(
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
                    onPressed: () => _handleEnterLobby(),
                    child: const Text("Join"))
              ],
            );
          } else if (notifier.state == NotifierState.loading) {
            // loading spinner while loading
            return const CircularProgressIndicator();
          }
          _handleStateChange(notifier);
          return Container();
        }),
      ),
    ], context);
  }

  void _handleEnterLobby() async {
    // here we simply invoke the wrapper to the api call
    final playerData = Provider.of<User>(context, listen: false).playerData;
    Provider.of<ApiChangeNotifier>(context, listen: false)
        .enterLobby(_lobbyCode.text, playerData.id, playerData.nickname);
  }
}
