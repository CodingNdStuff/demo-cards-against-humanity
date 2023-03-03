// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:cards_against_humanity/models/black_card.dart';
import 'package:cards_against_humanity/models/lobby.dart';
import 'package:cards_against_humanity/models/player.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClientWrapper with ChangeNotifier {
  String broker = 'ws://10.0.2.2';
  int port = 8080;
  // String clientIdentifier = 'android';
  static MqttServerClient? client;
  static MqttClientConnectionStatus? connectionState;
  StreamSubscription? subscription;
  Lobby? lobby;
  void _subscribeToTopic(String topic) {
    try {
      if (connectionState?.state == MqttConnectionState.connected) {
        print('[MQTT client] Subscribing to ${topic.trim()}');
        client!.subscribe(topic, MqttQos.exactlyOnce);
      }
    } catch (e) {
      print(e);
    }
  }

  void connect(String topic, String playerId) async {
    client = MqttServerClient.withPort(broker, playerId, port);
    client?.useWebSocket = true;
    client?.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    // client?.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(playerId)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce)
        .withWillTopic("willTopic")
        .withWillMessage(json.encode(playerId))
        .withWillQos(MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client?.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client!.connect(playerId);
    } catch (e) {
      print(e);
      disconnect(playerId);
    }

    /// Check if we are connected
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      print('[MQTT client] connected');
      connectionState = client?.connectionStatus;
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client?.connectionStatus?.state}');
      disconnect(playerId);
    }

    subscription = client?.updates?.listen(_onMessage);
    _subscribeToTopic(topic);
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    print("message received");
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String topic = event[0].topic;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    final lobbyJsonObj = json.decode(message);
    List<dynamic> playerListObject = lobbyJsonObj["players"] as List<dynamic>;
    List<Player> playerList = playerListObject
        .map((e) => Player.inLobby(e["id"], e["nickname"], e["ready"] as bool))
        .toList();
    lobby = Lobby(
      id: topic,
      roundDuration: lobbyJsonObj["roundDuration"] as int,
      maxRoundNumber: lobbyJsonObj["maxRoundNumber"] as int,
      currentRound: lobbyJsonObj["currentRound"] as int,
      players: playerList,
      currentBlackCard: lobbyJsonObj["currentBlackCard"] as BlackCard?,
    );
    notifyListeners();
  }

  void _publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void disconnect(String playerId) {
    print('[MQTT client] _disconnect()');
    _publish("${lobby?.id}/willmsg", json.encode(playerId));
    client?.disconnect();
    //_onDisconnected();
  }
}
