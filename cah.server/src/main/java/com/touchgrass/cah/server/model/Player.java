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
    private boolean isReady = false;
    private boolean isMyTurn = false;
    private int score = 0;
    private ArrayList<WhiteCard> hand = new ArrayList<>();

    public Player(String id, String nickname) {
        this.id = id;
        this.nickname = nickname;
    }
}
