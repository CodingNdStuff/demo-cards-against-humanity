import 'dart:math';

import 'package:cards_against_humanity/Themes/general_themes.dart';
import 'package:cards_against_humanity/helpers/api_change_notifier.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/models/player.dart';
import 'package:cards_against_humanity/models/user.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/screens/inGame/game_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_creation_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_entering_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => MqttClientWrapper())),
        ChangeNotifierProvider(
            create: ((context) => User(
                playerData: Player.basic(DateTime.now().toString(),
                    "player-${Random().nextInt(100000)}")))),
        ChangeNotifierProvider(create: ((context) => ApiChangeNotifier())),
      ],
      child: MaterialApp(
        title: 'Cards Against Humanity',
        theme: AppThemes.themeData(context),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          LobbyCreationScreen.routeName: (ctx) => const LobbyCreationScreen(),
          LobbyEnteringScreen.routeName: (ctx) => const LobbyEnteringScreen(),
          LobbyScreen.routeName: (ctx) => const LobbyScreen(),
          GameScreen.routeName: (ctx) => const GameScreen(),
        },
        // initialRoute: HomeScreen.routeName,
        initialRoute: GameScreen.routeName,
      ),
    );
  }
}
