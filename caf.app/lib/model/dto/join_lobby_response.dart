import 'package:json_annotation/json_annotation.dart';

part 'join_lobby_response.g.dart';

@JsonSerializable()
class JoinLobbyResponse {
  JoinLobbyResponse(this.playerId);

  String playerId;

  factory JoinLobbyResponse.fromJson(Map<String, dynamic> json) =>
      _$JoinLobbyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JoinLobbyResponseToJson(this);
}
