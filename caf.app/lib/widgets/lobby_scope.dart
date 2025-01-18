import 'package:cards_against_humanity/viewmodel/lobby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyScope extends StatelessWidget {
  final Widget child;

  const LobbyScope({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LobbyViewModel>(
      create: (_) => LobbyViewModel(),
      child: child,
    );
  }
}
