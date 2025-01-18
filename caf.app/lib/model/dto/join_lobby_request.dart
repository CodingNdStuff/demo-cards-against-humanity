import 'package:json_annotation/json_annotation.dart';

part 'join_lobby_request.g.dart';

@JsonSerializable()
class JoinLobbyRequest {
  JoinLobbyRequest(this.nickname);

  String nickname;

  factory JoinLobbyRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinLobbyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinLobbyRequestToJson(this);
}
