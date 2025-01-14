package com.touchgrass.cah.server.model;

import com.touchgrass.cah.server.service.JsonService;
import lombok.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Lobby {
    private String id;
    private LobbyStatus status;
    private int roundDuration;
    private int maxRoundNumber;
    private int currentRound;
    private Round round;
    @Autowired
    private Deck deck;
    private HashMap<String, Player> playerList;

    void Lobby(int roundDuration, int maxRoundNumber, Player host) {
        id = UUID.randomUUID().toString();
        status = LobbyStatus.open;
        this.roundDuration = roundDuration;
        this.maxRoundNumber = maxRoundNumber;
        this.currentRound = 0;
        round = new Round();
        playerList = new HashMap<>();
        playerList.put(host.getId(), host);
        host.setMyTurn(true);
        round.setCurrentBlackCard(deck.drawBlackCard());
    }
}
