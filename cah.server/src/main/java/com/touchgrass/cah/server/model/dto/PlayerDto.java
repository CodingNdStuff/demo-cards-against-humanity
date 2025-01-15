package com.touchgrass.cah.server.model.dto;

import com.touchgrass.cah.server.model.Player;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@Getter
@Setter
@ToString
public class PlayerDto {
    private String nickname;
    private boolean isReady;
    private boolean isMyTurn;
    private int score;

    public PlayerDto(Player player) {
        this.nickname = player.getNickname();
        this.isReady = player.isReady();
        this.isMyTurn = player.isMyTurn();
        this.score = player.getScore();
    }
}
