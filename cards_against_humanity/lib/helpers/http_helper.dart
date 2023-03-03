// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cards_against_humanity/exceptions/connection_exception.dart';
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
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      // .timeout(const Duration(seconds: 5));
      if (response.statusCode == 201) return true;
      throw Failure(code: 2, message: "Specified lobby does not exsists.");
    } on HttpException {
      throw Failure(code: 1, message: "Looks like the service is unavailable.");
    } on TimeoutException {
      throw Failure(code: 1, message: "Server might be offline.");
    } on SocketException {
      throw Failure(code: 1, message: "Server might be offline.");
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
      throw Failure(
          code: 2, message: "Specified lobby/player does not exsists.");
    } on HttpException {
      throw Failure(code: 1, message: "Looks like the service is unavailable.");
    } on TimeoutException {
      throw Failure(code: 1, message: "Server might be offline.");
    } on SocketException {
      throw Failure(code: 1, message: "Server might be offline.");
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
      throw Failure(code: 2, message: "Bad request error.");
    } on HttpException {
      throw Failure(code: 1, message: "Looks like the service is unavailable.");
    } on TimeoutException {
      throw Failure(code: 1, message: "Server might be offline.");
    } on SocketException {
      throw Failure(code: 1, message: "Server might be offline.");
    }
  }
}
