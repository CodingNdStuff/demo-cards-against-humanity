import 'package:cards_against_humanity/Themes/general_themes.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_creation_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_entering_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.themeData(context),
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        LobbyCreationScreen.routeName: (ctx) => const LobbyCreationScreen(),
        LobbyEnteringScreen.routeName: (ctx) => const LobbyEnteringScreen(),
        LobbyScreen.routeName: (ctx) => const LobbyScreen(),
      },
      initialRoute: HomeScreen.routeName,
    );
  }
}
