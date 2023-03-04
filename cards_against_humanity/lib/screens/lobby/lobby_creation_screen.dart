import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:cards_against_humanity/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class LobbyCreationScreen extends StatefulWidget {
  static const routeName = "/lobby-creation";
  const LobbyCreationScreen({super.key});

  @override
  State<LobbyCreationScreen> createState() => _LobbyCreationScreenState();
}

class _LobbyCreationScreenState extends State<LobbyCreationScreen> {
  double _maxRoundNumber = 10;
  double _roundDuration = 30;

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
        final lobbyId = notifier.post as String;
        notifier.reset();
        Navigator.of(context).pushNamedAndRemoveUntil(
            // if successful, navigate to lobby
            LobbyScreen.routeName,
            ((route) => false),
            arguments: lobbyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayouts.mainLayout([
      Consumer<ApiChangeNotifier>(
        builder: ((_, notifier, __) {
          if (notifier.state == NotifierState.initial) {
            return Column(
              children: [
                SliderInput(
                  text: "Number of rounds",
                  value: _maxRoundNumber,
                  setValue: (newValue) {
                    setState(() {
                      _maxRoundNumber = newValue;
                    });
                  },
                  min: 5.0,
                  max: 15.0,
                ),
                SliderInput(
                  text: "Round duration",
                  value: _roundDuration,
                  setValue: (newValue) {
                    setState(() {
                      _roundDuration = newValue;
                    });
                  },
                  min: 15.0,
                  max: 60.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => _handleCreateLobby(notifier),
                  child: const Text("Create Lobby"),
                ),
              ],
            );
          } else if (notifier.state == NotifierState.loading) {
            return const CircularProgressIndicator();
          }
          _handleStateChange(notifier);
          return Container();
        }),
      ),
    ], context);
  }

  void _handleCreateLobby(notifier) {
    final playerData = Provider.of<User>(context, listen: false).playerData;
    notifier.createLobby(
      playerData.id,
      playerData.nickname,
      _roundDuration.toInt(),
      _maxRoundNumber.toInt(),
    );
  }
}

class SliderInput extends StatelessWidget {
  const SliderInput(
      {super.key,
      required this.text,
      required this.value,
      required this.setValue,
      required this.min,
      required this.max});
  final String text;
  final double value;
  final Function setValue;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(text),
          ),
          Expanded(
            flex: 8,
            child: Slider(
                min: min,
                max: max,
                value: value,
                onChanged: (double val) {
                  setValue(val);
                }),
          ),
          Expanded(
            flex: 1,
            child: Text("${value.toInt()}"),
          ),
        ],
      ),
    );
  }
}
