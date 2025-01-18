// // ignore_for_file: avoid_print
/*
// import 'dart:async';
// import 'dart:convert';
// import 'package:cards_against_humanity/model/black_card.dart';
// import 'package:cards_against_humanity/model/lobby.dart';
// import 'package:cards_against_humanity/model/player.dart';
// import 'package:cards_against_humanity/model/white_card.dart';
// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// class MqttClientWrapper with ChangeNotifier {
//   String broker = 'ws://demo-cau.ddns.net';
//   int port = 8080;
//   // String clientIdentifier = 'android';
//   static MqttServerClient? client;
//   // static MqttBrowserClient? client;
//   static MqttClientConnectionStatus? connectionState;
//   StreamSubscription? subscription;
//   Lobby? lobby;
//   List<WhiteCard>? hand;
//   List<dynamic>? proposals;

//   void _subscribeToTopic(String topic) {
//     return;
//     try {
//       if (connectionState?.state == MqttConnectionState.connected) {
//         print('[MQTT client] Subscribing to ${topic.trim()}');
//         client!.subscribe(topic, MqttQos.exactlyOnce);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   // void _unsubscribeToTopic(String topic) {
//   //   try {
//   //     if (connectionState?.state == MqttConnectionState.connected) {
//   //       print('[MQTT client] Unsubscribing to ${topic.trim()}');
//   //       client!.unsubscribe(topic);
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   void connect(String topic, String playerId) async {
//     return;
//     print("acab");
//     client = MqttServerClient.withPort(broker, playerId, port);
//     // client = MqttBrowserClient.withPort(broker, playerId, port); // for web apps
//     client?.useWebSocket = true;
//     client?.keepAlivePeriod = 30;

//     /// Add the unsolicited disconnection callback
//     // client?.onDisconnected = _onDisconnected;

//     /// Create a connection message to use or use the default one. The default one sets the
//     /// client identifier, any supplied username/password, the default keepalive interval(60s)
//     /// and clean session, an example of a specific one below.
//     final MqttConnectMessage connMess = MqttConnectMessage()
//         .withClientIdentifier(playerId)
//         .startClean() // Non persistent session for testing
//         .withWillQos(MqttQos.atMostOnce)
//         .withWillTopic("willTopic")
//         .withWillMessage(json.encode("$topic/$playerId"))
//         .withWillQos(MqttQos.atMostOnce);
//     print('[MQTT client] MQTT client connecting....');
//     client?.connectionMessage = connMess;

//     /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
//     /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
//     /// never send malformed messages.
//     try {
//       await client!.connect(playerId);
//     } catch (e) {
//       print(e);
//       disconnect();
//       return;
//     }

//     /// Check if we are connected
//     if (client?.connectionStatus?.state == MqttConnectionState.connected) {
//       print('[MQTT client] connected');
//       connectionState = client?.connectionStatus;
//     } else {
//       print('[MQTT client] ERROR: MQTT client connection failed - '
//           'disconnecting, state is ${client?.connectionStatus?.state}');
//       disconnect();
//       return;
//     }

//     subscription = client?.updates?.listen(_onMessage);
//     _subscribeToTopic(topic);
//     _subscribeToTopic("$topic/$playerId");
//     _subscribeToTopic("$topic/voting");
//   }

//   void _onMessage(List<MqttReceivedMessage> event) {
//     return;
//     print("message received");
//     final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
//     final String topic = event[0].topic;
//     final String message =
//         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//     if (message.isEmpty) return;

//     final lobbyJsonObject = jsonDecode(message);
//     print(lobbyJsonObject);
//     if (topic.contains("voting")) {
//       _handleProposalsUpdates(lobbyJsonObject);
//     } else if (topic.contains("/")) {
//       _handleHandUpdates(lobbyJsonObject);
//     } else {
//       _handleLobbyUpdates(lobbyJsonObject, topic);
//     }

//     notifyListeners();
//   }

//   void _handleProposalsUpdates(List<dynamic> proposalsJsonObject) {
//     return;
//     proposals = proposalsJsonObject.map(
//       (o) {
//         final List<dynamic> playedCardsObjects = o["playedCards"];
//         final cardList = playedCardsObjects
//             .map((c) => WhiteCard(c["id"], Uri.decodeComponent(c["text"])))
//             .toList();
//         return ({
//           "playerId": o["playerId"],
//           "playedCards": cardList,
//         });
//       },
//     ).toList();
//     print("proposals are done");
//   }

//   void _handleHandUpdates(List<dynamic> handJsonObject) {
//     return;
//     hand = handJsonObject
//         .map(
//           (c) => WhiteCard(
//             c["id"],
//             Uri.decodeComponent(c["text"]),
//           ),
//         )
//         .toList();
//     print("hand is done");
//   }

//   void _handleLobbyUpdates(lobbyJsonObject, topic) {
//     LobbyStatus phase = LobbyStatus.values.byName(lobbyJsonObject[
//         "status"]); // sort of casting from string to enum status
//     if (phase == LobbyStatus.open) {
//       _updateOpenLobby(lobbyJsonObject, topic);
//     } else {
//       _updateOngoingLobby(lobbyJsonObject, topic);
//     }
//   }

//   void _updateOpenLobby(lobbyJsonObject, lobbyId) {
//     print("updating open");
//     List<dynamic> playerListObject =
//         lobbyJsonObject["players"] as List<dynamic>;
//     List<Player> playerList = playerListObject
//         .map((e) => Player.inLobby(
//               e["id"],
//               Uri.decodeComponent(e["nickname"]),
//               e["ready"] as bool,
//             ))
//         .toList();
//     lobby = Lobby.open(
//       id: lobbyId,
//       roundDuration: lobbyJsonObject["roundDuration"] as int,
//       maxRoundNumber: lobbyJsonObject["maxRoundNumber"] as int,
//       players: playerList,
//     );
//     print("updated open");
//   }

//   void _updateOngoingLobby(lobbyJsonObject, lobbyId) {
//     print("updating ongoing");
//     final oldLobby = lobby;
//     List<dynamic> playerListObject =
//         lobbyJsonObject["players"] as List<dynamic>;
//     List<Player> playerList = playerListObject
//         .map((e) => Player.inGame(
//               e["id"],
//               Uri.decodeComponent(e["nickname"]),
//               e["ready"] as bool,
//               e["score"] as int,
//               e["isMyTurn"] as bool,
//             ))
//         .toList();
//     BlackCard card;
//     if (oldLobby?.currentBlackCard?.id ==
//         lobbyJsonObject["currentBlackCard"]["id"]) {
//       //insensitive to lobby variations when the black card is not involved
//       card = oldLobby!.currentBlackCard!;
//     } else {
//       card = BlackCard(
//           lobbyJsonObject["currentBlackCard"]["id"] as int,
//           Uri.decodeComponent(lobbyJsonObject["currentBlackCard"]["text"]),
//           lobbyJsonObject["currentBlackCard"]["numberOfBlanks"] as int);
//     }
//     lobby = Lobby(
//       id: lobbyId,
//       roundDuration: lobbyJsonObject["roundDuration"] as int,
//       maxRoundNumber: lobbyJsonObject["maxRoundNumber"] as int,
//       players: playerList,
//       currentRound: lobbyJsonObject["currentRound"] as int,
//       currentBlackCard: card,
//       phase: status.values.byName(lobbyJsonObject["status"]),
//     );

//     if (lobby?.phase == status.closed) disconnect();
//   }

//   // void _publish(String topic, String message) {
//   //   final builder = MqttClientPayloadBuilder();
//   //   builder.addString(message);
//   //   client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
//   // }

//   void disconnect() {
//     print('[MQTT client] _disconnect()');
//     // _publish("${lobby?.id}/willmsg", json.encode(playerId));
//     client?.disconnect();
//     subscription?.cancel();
//     //_onDisconnected();
//   }

//   void resetLobbyData() {
//     lobby = null;
//     hand = null;
//     proposals = null;
//   }

//   void placeCard(WhiteCard card) {
//     lobby?.currentBlackCard?.placedCards.add(card);
//     notifyListeners();
//   }

//   void takeCardsBack() {
//     // ignore: avoid_function_literals_in_foreach_calls
//     lobby?.currentBlackCard?.placedCards.forEach((card) {
//       hand?.add(card);
//     });
//     lobby?.currentBlackCard?.placedCards.clear();
//     notifyListeners();
//   }
// }
*/
