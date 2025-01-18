import 'package:cards_against_humanity/data/implementation/local_data_source.dart';
import 'package:cards_against_humanity/data/local_repository.dart';
import 'package:cards_against_humanity/themes/general_themes.dart';
import 'package:cards_against_humanity/screens/home/home_screen.dart';
import 'package:cards_against_humanity/screens/inGame/game_screen.dart';
import 'package:cards_against_humanity/screens/inGame/post_game_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_creation_screen.dart';
import 'package:cards_against_humanity/screens/lobby/lobby_entering_screen.dart';
import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:cards_against_humanity/widgets/view_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  getIt.registerSingleton<LocalRepository>(LocalDataSource(),
      signalsReady: true);
  await getIt<LocalRepository>().init();
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
