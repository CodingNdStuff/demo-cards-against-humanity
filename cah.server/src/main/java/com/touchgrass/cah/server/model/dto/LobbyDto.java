package com.touchgrass.cah.server.model.dto;

import com.touchgrass.cah.server.model.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;

@AllArgsConstructor
@Getter
@Setter
@ToString
public class LobbyDto {
    private String id;
    private LobbyStatus status;
    private int roundDuration;
    private int maxRoundNumber;
    private int currentRound;
    private Round round;
    private BlackCard currentBlackCard;
    private ArrayList<PlayerDto> playerList;

    public LobbyDto(Lobby lobby) {
        this.id = lobby.getId();
        this.status = lobby.getStatus();
        this.roundDuration = lobby.getRoundDuration();
        this.maxRoundNumber = lobby.getMaxRoundNumber();
        this.currentRound = lobby.getCurrentRound();
        this.currentBlackCard = lobby.getRound().getCurrentBlackCard();
        this.round = lobby.getRound();

        // Convert Player objects to PlayerDto
        this.playerList = new ArrayList<>();
        for (Player player : lobby.getPlayerList().values()) {
            this.playerList.add(new PlayerDto(player));
        }
    }
}
