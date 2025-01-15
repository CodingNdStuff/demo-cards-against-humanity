package com.touchgrass.cah.server.model.dto;

import com.touchgrass.cah.server.model.BlackCard;
import com.touchgrass.cah.server.model.Round;
import com.touchgrass.cah.server.model.WhiteCard;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;
import java.util.HashMap;

@AllArgsConstructor
@Getter
@Setter
@ToString
public class RoundDto {
    private BlackCard currentBlackCard;
    private HashMap<String, ArrayList<WhiteCard>> playedCards = new HashMap<>();
    private String winnerNickname;
    private ArrayList<String> winnerCardText;

    public RoundDto(Round round) {
        this.currentBlackCard = round.getCurrentBlackCard();
        this.playedCards = round.getPlayedCards();
        this.winnerNickname = round.getWinnerNickname();
        this.winnerCardText = round.getWinnerCardTexts();
    }
}
