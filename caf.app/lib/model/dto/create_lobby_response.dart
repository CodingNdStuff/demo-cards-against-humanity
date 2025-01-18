import 'package:json_annotation/json_annotation.dart';

part 'create_lobby_response.g.dart';

@JsonSerializable()
class CreateLobbyResponse {
  CreateLobbyResponse(this.lobbyId, this.playerId);

  String lobbyId;
  String playerId;

  factory CreateLobbyResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateLobbyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateLobbyResponseToJson(this);
}
