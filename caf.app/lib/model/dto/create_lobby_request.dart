import 'package:json_annotation/json_annotation.dart';

part 'create_lobby_request.g.dart';

@JsonSerializable()
class CreateLobbyRequest {
  CreateLobbyRequest(this.nickname, this.roundDuration, this.maxRoundNumber);

  String nickname;
  int roundDuration;
  int maxRoundNumber;

  factory CreateLobbyRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLobbyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateLobbyRequestToJson(this);
}
