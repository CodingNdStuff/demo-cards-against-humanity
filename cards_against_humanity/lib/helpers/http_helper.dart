// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class API {
  static const domain = "10.0.2.2:3001";
  static Future<bool> enterLobby(
    String lobbyId,
    String playerId,
    String nickname,
  ) async {
    var url = Uri.http(domain, '/api/joinLobby/$lobbyId');
    final body = json.encode({
      "playerId": playerId,
      "nickname": nickname,
    });
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: body,
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 201) return true;
      return false;
    } catch (e) {
      debugPrint("Error in API.enterLobby: $e");
      throw HttpException("Error in API.enterLobby: $e");
    }
  }

  static Future<bool> setPlayerReady(
    String lobbyId,
    String playerId,
  ) async {
    var url = Uri.http(domain, '/api/setPlayerReady/$lobbyId/$playerId');
    try {
      final response = await http
          .post(
            url,
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 201) return true;
      return false;
    } catch (e) {
      debugPrint("Error in API.setPlayerReady: $e");
      throw HttpException("Error in API.setPlayerReady: $e");
    }
  }

  static Future<String> createLobby(
    String playerId,
    String nickname,
    int roundDuration,
    int maxRoundNumber,
  ) async {
    final url = Uri.http(domain, '/api/createLobby');
    final body = json.encode({
      "playerId": playerId,
      "nickname": nickname,
      "roundDuration": roundDuration,
      "maxRoundNumber": maxRoundNumber
    });
    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: body,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) return json.decode(response.body);
      return "";
    } catch (e) {
      debugPrint("Error in API.createLobby: $e");
      throw HttpException("Error in API.createLobby: $e");
    }
  }
}
