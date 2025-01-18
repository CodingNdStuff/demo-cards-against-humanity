import 'package:cards_against_humanity/model/player.dart';
import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  Player playerData;
  User({required this.playerData});

  void changeNickname(String newNickname) {
    playerData.setNickname(newNickname);
    notifyListeners();
  }
}
