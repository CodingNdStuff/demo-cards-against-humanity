package com.touchgrass.cah.server.model;

import lombok.*;

import java.util.ArrayList;
import java.util.HashMap;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Round {
    private BlackCard currentBlackCard;
    private HashMap<String, ArrayList<WhiteCard>> playedCards = new HashMap<>();
}
