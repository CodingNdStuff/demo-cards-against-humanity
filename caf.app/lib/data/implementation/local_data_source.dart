import 'package:cards_against_humanity/data/local_repository.dart';
import 'package:cards_against_humanity/model/player.dart';
import 'package:cards_against_humanity/model/restore_lobby_data.dart';
import 'package:hive_ce_flutter/adapters.dart';

class LocalDataSource implements LocalRepository {
  static const lobbyBox = 'lobby';
  late Box<dynamic> box;
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    box = await Hive.openBox(lobbyBox);
    _isInitialized = true;
  }

  @override
  bool isInitialized() {
    return _isInitialized;
  }

  @override
  void storeLobbyData(Player user, String lobbyId) {
    box.put("userId", user.id);
    box.put("userNickname", user.nickname);
    box.put("lobbyId", lobbyId);
  }

  @override
  RestoreLobbyData recoverLobbyData() {
    String userId = box.get("userId") ?? "";
    String userNickname = box.get("userNickname") ?? "";
    String lobbyId = box.get("lobbyId") ?? "";
    return RestoreLobbyData(lobbyId, userId, userNickname);
  }

  @override
  void deleteLobbyData() {
    box.delete("userId");
    box.delete("userNickname");
    box.delete("lobbyId");
  }
}
