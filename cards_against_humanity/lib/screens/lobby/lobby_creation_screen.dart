import 'package:cards_against_humanity/helpers/http_helper.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final playerData = Provider.of<User>(context, listen: false).playerData;
    return CustomLayouts.mainLayout([
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
        onPressed: () => _handleCreateLobby(playerData.id, playerData.nickname),
        child: const Text("Create Lobby"),
      ),
    ], context);
  }

  void _handleCreateLobby(String playerId, String nickname) {
    API
        .createLobby(
      playerId,
      nickname,
      _roundDuration.toInt(),
      _maxRoundNumber.toInt(),
    )
        .then((lobbyId) {
      if (lobbyId.isEmpty) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          LobbyScreen.routeName, ((route) => false),
          arguments: lobbyId);
    });
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
