import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class API {
  static const domain = "10.0.2.2:3001";
  static Future<void> enterLobby(
      String lobbyId, String playerId, String nickname) async {
    var url = Uri.http(domain, '/api/joinLobby/$lobbyId');
    var body = json.encode({
      "playerId": playerId,
      "nickname": nickname,
    });

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  static Future<void> setPlayerReady(String lobbyId, String playerId) async {
    var url = Uri.http(domain, '/api/setPlayerReady/$lobbyId/$playerId');
    var response = await http.post(
      url,
    );
  }
}
