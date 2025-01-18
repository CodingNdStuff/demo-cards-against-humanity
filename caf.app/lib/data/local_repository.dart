import 'package:cards_against_humanity/model/player.dart';
import 'package:cards_against_humanity/model/restore_lobby_data.dart';

abstract class LocalRepository {
  Future<void> init();

  bool isInitialized();

  void storeLobbyData(Player user, String lobbyId);

  RestoreLobbyData recoverLobbyData();

  void deleteLobbyData() {}
}
