import 'dart:async';
import 'dart:collection';

import 'package:cards_against_humanity/model/dto/lobby_dto.dart';
import 'package:cards_against_humanity/model/dto/white_card_dto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  StreamSubscription? lobbySubscription;
  StreamSubscription? handSubscription;

  Future<void> readLobbyData(
      String lobbyId, Function(LobbyDto) callback) async {
    try {
      lobbySubscription =
          _databaseReference.child('/$lobbyId/lobbyData').onValue.listen(
                (DatabaseEvent event) =>
                    _handleLobbyData(event.snapshot, callback),
              );
    } catch (e) {
      debugPrint('Error reading data: $e');
    }
  }

  Future<bool> readLobbyDataSnapshot(
      String lobbyId, Function(LobbyDto) callback) async {
    try {
      DataSnapshot snapshot =
          await _databaseReference.child('/$lobbyId/lobbyData').get();
      return _handleLobbyData(snapshot, callback);
    } catch (e) {
      debugPrint('Error reading data: $e');
      return false;
    }
  }

  bool _handleLobbyData(DataSnapshot snapshot, Function(LobbyDto) callback) {
    var data = snapshot.value;
    if (data == null) return false;

    if (data is Map) {
      Map<String, dynamic> lobbyData = Map<String, dynamic>.from(data);

      lobbyData = _convertNestedMaps(lobbyData);
      LobbyDto lobby = LobbyDto.fromJson(lobbyData);

      callback(lobby);
    }
    return true;
  }

  Future<void> readPlayerHandData(String lobbyId, String nickname,
      Function(List<WhiteCardDto>) callback) async {
    try {
      handSubscription =
          _databaseReference.child('/$lobbyId/hands/$nickname').onValue.listen(
                (DatabaseEvent event) =>
                    _handlePlayerHandData(event.snapshot, callback),
              );
    } catch (e) {
      debugPrint('Error reading data: $e');
    }
  }

  Future<void> readPlayerHandDataSnapshot(String lobbyId, String nickname,
      Function(List<WhiteCardDto>) callback) async {
    try {
      DataSnapshot snapshot =
          await _databaseReference.child('/$lobbyId/hands/$nickname').get();
      _handlePlayerHandData(snapshot, callback);
    } catch (e) {
      debugPrint('Error reading data: $e');
    }
  }

  bool _handlePlayerHandData(
      DataSnapshot snapshot, Function(List<WhiteCardDto>) callback) {
    var data = snapshot.value;
    if (data == null) return false;
    print(data);
    if (data is List) {
      List<WhiteCardDto> hand = data
          .map(
            (e) => WhiteCardDto(e["id"], e["text"]),
          )
          .toList();

      callback(hand);
    }
    return true;
  }

  void resetSubscriptions() {
    lobbySubscription?.cancel();
    handSubscription?.cancel();
  }

  Map<String, dynamic> _convertNestedMaps(Map<String, dynamic> map) {
    map.forEach((key, value) {
      if (value is LinkedHashMap) {
        // Convert nested LinkedHashMap to a standard Map
        map[key] = Map<String, dynamic>.from(value);
        map[key] = _convertNestedMaps(map[key]);
      } else if (value is List) {
        // If it's a list, recursively process its items
        map[key] = value.map((item) {
          if (item is LinkedHashMap) {
            var map = Map<String, dynamic>.from(item);
            return _convertNestedMaps(map);
          }
          return item;
        }).toList();
      }
    });
    return map;
  }
}
