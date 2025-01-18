import 'package:json_annotation/json_annotation.dart';

part 'play_card_request.g.dart';

@JsonSerializable()
class PlayCardRequest {
  PlayCardRequest(this.cardIds);

  List<int> cardIds;

  factory PlayCardRequest.fromJson(Map<String, dynamic> json) =>
      _$PlayCardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PlayCardRequestToJson(this);
}
