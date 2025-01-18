import 'dart:math';

import 'package:cards_against_humanity/themes/general_themes.dart';
import 'package:cards_against_humanity/helpers/api_service.dart';
import 'package:cards_against_humanity/helpers/mqtt_helper.dart';
import 'package:cards_against_humanity/model/player.dart';
import 'package:cards_against_humanity/model/user.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/screens/inGame/game_screen.dart';
import 'package:cards_against_humanity/screens/inGame/post_game_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_creation_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_entering_screen.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:cards_against_humanity/widgets/lobby_scope.dart';
import 'package:cards_against_humanity/widgets/view_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LobbyViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Cards Against Humanity',
        theme: AppThemes.themeData(context),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          LobbyCreationScreen.routeName: (ctx) => const LobbyCreationScreen(),
          LobbyEnteringScreen.routeName: (ctx) => const LobbyEnteringScreen(),
          GameScreen.routeName: (ctx) => const GameScreen(),
          PostGameScreen.routeName: (ctx) => const PostGameScreen(),
        },
        initialRoute: HomeScreen.routeName,
        builder: (context, child) => ViewControllerScope(child: child!),
      ),
    );
  }
}
