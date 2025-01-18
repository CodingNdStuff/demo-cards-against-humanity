// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cards_against_humanity/exceptions/connection_exception.dart';
import 'package:cards_against_humanity/model/custom_exception.dart';
import 'package:cards_against_humanity/model/dto/create_lobby_request.dart';
import 'package:cards_against_humanity/model/dto/create_lobby_response.dart';
import 'package:cards_against_humanity/model/dto/join_lobby_request.dart';
import 'package:cards_against_humanity/model/dto/join_lobby_response.dart';
import 'package:cards_against_humanity/model/dto/play_card_request.dart';
import 'package:cards_against_humanity/model/dto/vote_winner_request.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const domain = "touchgrass.bounceme.net:8080";
  static const _headers = {
    "Content-Type": "application/json",
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'false',
  };
  Future<JoinLobbyResponse> joinLobby(
    String lobbyId,
    String nickname,
  ) async {
    var url = Uri.http(domain, '/api/joinLobby/$lobbyId');
    final body = JoinLobbyRequest(nickname).toJson();
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      // .timeout(const Duration(seconds: 5));
      if (response.statusCode == 201)
        return JoinLobbyResponse.fromJson(jsonDecode(response.body));

      throw Customexception(2, "Specified code corresponds to no open lobby");
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> setPlayerReady(
    String lobbyId,
    String playerId,
  ) async {
    var url = Uri.http(domain, '/api/setPlayerReady/$lobbyId/$playerId');
    try {
      final response = await http.post(
        url,
        headers: _headers,
      );
      if (response.statusCode == 201) return;
      throw Failure(
          code: 2, message: "Specified lobby/player does not exists.");
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<CreateLobbyResponse> createLobby(
    String nickname,
    int roundDuration,
    int maxRoundNumber,
  ) async {
    final url = Uri.http(domain, '/api/createLobby');
    final body =
        CreateLobbyRequest(nickname, roundDuration, maxRoundNumber).toJson();
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201)
        return CreateLobbyResponse.fromJson(jsonDecode(response.body));
      throw Failure(code: 2, message: "Bad request error.");
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> playCard(
    String lobbyId,
    String playerId,
    List<int> cardIds,
  ) async {
    final url = Uri.http(domain, '/api/playCard/$lobbyId/$playerId');
    final body = PlayCardRequest(cardIds);

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) return;
      throw Failure(code: 2, message: "Bad request error.");
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<void> voteWinner(
    String lobbyId,
    String playerId,
    String voterPlayerNickname,
  ) async {
    final url = Uri.http(domain, '/api/voteWinner/$lobbyId/$playerId');
    final body = VoteWinnerRequest(voterPlayerNickname);
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) return;
      throw Failure(code: 2, message: "Bad request error.");
    } catch (e) {
      throw _handleException(e);
    }
  }

  Customexception _handleException(Object e) {
    if (e is HttpException) {
      return Customexception(1, "Looks like the service is unavailable.");
    } else if (e is TimeoutException) {
      return Customexception(1, "Server might be offline.");
    } else if (e is SocketException) {
      return Customexception(1, "Server might be offline.");
    }
    return Customexception(1, "Generic error: $e");
  }
}
