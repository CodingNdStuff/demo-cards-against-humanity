import 'dart:collection';

import 'package:cards_against_humanity/model/black_card.dart';
import 'package:cards_against_humanity/model/dto/round_dto.dart';
import 'package:cards_against_humanity/model/white_card.dart';

class Round {
  Round(
    this.currentBlackCard,
    this.playedCards,
    this.winnerNickname,
    this.winnerCardTexts,
  );

  Round.fromDto(RoundDto dto) {
    if (dto.currentBlackCard != null) {
      currentBlackCard = BlackCard.fromDto(dto.currentBlackCard!);
    } else {
      currentBlackCard = null;
    }

    if (dto.playedCards != null) {
      playedCards = dto.playedCards!.map((key, list) {
        return MapEntry(
            key, list.map((card) => WhiteCard.fromDto(card)).toList());
      });
    } else {
      playedCards = {};
    }
    winnerNickname = dto.winnerNickname;
    winnerCardTexts = dto.winnerCardTexts;
  }

  BlackCard? currentBlackCard;
  Map<String, List<WhiteCard>> playedCards = HashMap();
  String? winnerNickname;
  List<String>? winnerCardTexts;

  List<WhiteCard> getMyPlacedCards(String nickname) {
    return playedCards[nickname] ?? [];
  }

  Map<String, List<WhiteCard>> getEveryOneElsesPlacedCards(String nickname) {
    return Map.fromEntries(
      playedCards.entries.where((entry) => entry.key != nickname),
    );
  }
}
