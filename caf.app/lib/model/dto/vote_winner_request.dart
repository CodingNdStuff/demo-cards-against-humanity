import 'package:json_annotation/json_annotation.dart';

part 'vote_winner_request.g.dart';

@JsonSerializable()
class VoteWinnerRequest {
  VoteWinnerRequest(this.votedPlayerNickname);

  String votedPlayerNickname;

  factory VoteWinnerRequest.fromJson(Map<String, dynamic> json) =>
      _$VoteWinnerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VoteWinnerRequestToJson(this);
}
