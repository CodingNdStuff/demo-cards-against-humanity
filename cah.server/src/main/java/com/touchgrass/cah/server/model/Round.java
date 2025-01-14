package com.touchgrass.cah.server.model;

import lombok.*;

import java.util.ArrayList;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Round {
    private BlackCard currentBlackCard;
    private ArrayList<WhiteCard> playedCards;
}
