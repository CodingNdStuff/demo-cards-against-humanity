import 'package:cards_against_humanity/screens/inGame/game_screen.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:cards_against_humanity/widgets/custom_layouts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyCreationScreen extends StatefulWidget {
  static const routeName = "lobby/creation";
  const LobbyCreationScreen({super.key});

  @override
  State<LobbyCreationScreen> createState() => _LobbyCreationScreenState();
}

class _LobbyCreationScreenState extends State<LobbyCreationScreen> {
  double _maxRoundNumber = 10;
  double _roundDuration = 30;

  @override
  Widget build(BuildContext context) {
    return CustomLayouts.mainLayout([
      Column(
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
            onPressed: () => _handleCreateLobby(context, _roundDuration, _maxRoundNumber),
            child: const Text("Create Lobby"),
          ),
        ],
      ),
    ], context);
  }

  void _handleCreateLobby(context, roundDuration, maxRoundNumber) async {
    final vm = Provider.of<LobbyViewModel>(context, listen: false);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    bool isSuccess = await vm.createLobby(args["nickname"]!, roundDuration,
        maxRoundNumber); //TODO gestire con storage
    if (isSuccess) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        // if successful, navigate to lobby
        GameScreen.routeName,
        (route) => false,
      );
    }
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
