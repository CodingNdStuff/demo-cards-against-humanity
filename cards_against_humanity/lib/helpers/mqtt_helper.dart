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
  String username = 'fcg.._seu_user_no_brokerrix';
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

  void connect(String topic) async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    ///

    client = MqttServerClient.withPort(broker, username, port);

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    client?.useWebSocket = true;
    // client?.port = 1883; //( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
    /// Set logging on if needed, defaults to off
    ///  client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client?.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    // client?.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(username)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client?.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client!.connect(username);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      print('[MQTT client] connected');
      connectionState = client?.connectionStatus;
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client?.connectionStatus?.state}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client?.updates?.listen(_onMessage);
    _subscribeToTopic(topic);
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    print("message received");
    print(event.length);
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

    print(lobby.toString());
    notifyListeners();
  }

  // void _publish(String topic, String message) {
  //   final builder = MqttClientPayloadBuilder();
  //   builder.addString(message);
  //   client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  // }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client?.disconnect();
    // _onDisconnected();
  }

  void serPlayerReady(lobbyId, playerId) {}
}
