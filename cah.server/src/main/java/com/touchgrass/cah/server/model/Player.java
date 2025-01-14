package com.touchgrass.cah.server.model;

import lombok.*;

import java.util.ArrayList;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Player {
    private String id;
    private String nickname;
    private boolean isReady;
    private boolean isMyTurn;
    private int score = 0;
    private ArrayList<WhiteCard> hand;
}
