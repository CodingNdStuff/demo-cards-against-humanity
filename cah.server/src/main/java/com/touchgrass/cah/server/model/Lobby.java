package com.touchgrass.cah.server.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.touchgrass.cah.server.configuration.Constants;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

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
    @JsonIgnore
    private Deck deck;
    private HashMap<String, Player> playerList;

    public Lobby(int roundDuration, int maxRoundNumber, Player host, Deck deck) {
        id = "11111"; // UUID.randomUUID().toString();
        status = LobbyStatus.open;
        this.roundDuration = roundDuration;
        this.maxRoundNumber = maxRoundNumber;
        this.currentRound = 1;
        round = new Round();
        playerList = new HashMap<>();
        playerList.put(host.getId(), host);
        host.setMyTurn(true);
        this.deck = deck;
        round.setCurrentBlackCard(deck.drawBlackCard());
    }

    public void addPlayer(Player player) {
        this.playerList.put(player.getId(), player);
        System.out.println("Added Player " + player.getId() + " " + player.getNickname());
    }

    public void setPlayerReady(String playerId) throws CustomException {
        Player p = playerList.get(playerId);
        if (p == null) throw new CustomException(404, "Player not found");
        p.setReady(true);
        System.out.println("Set Player ready " + playerId + " " + this.playerList.get(playerId));
    }

    public boolean checkAllReady() {
        for (Player p : this.playerList.values()) {
            if (!p.isReady()) return false;

        }
        return true;
    }

    public void resetAllPlayerReady() {
        for (Player p : this.playerList.values()) {
            if (!p.isMyTurn()) { // necessary otherwise you'd need to set this manually in a less efficient manner
                p.setReady(false);
            }
        }
    }

    public void refillHands() {
        for (Player p : this.playerList.values()) {
            ArrayList<WhiteCard> hand = p.getHand();
            while (hand.size() < Constants.HAND_SIZE) {
                hand.add(deck.drawWhiteCard());
            }
        }
    }

    public void playCard(@Size(min = 1, max = 32) String playerId, @NotNull @Size(min = 1) List<@NotNull Integer> cardIds) throws CustomException {
        if (this.status != LobbyStatus.play) throw new CustomException(409, "Cannot play a card right now");
        Player player = this.playerList.get(playerId);
        if (player == null) throw new CustomException(404, "Player not found");

        ArrayList<WhiteCard> playedCards = new ArrayList<>();
        int found = 0;
        ArrayList<WhiteCard> remainingCards = new ArrayList<>();
        for (WhiteCard c : player.getHand()) {
            if (cardIds.contains(c.getId())) {
                playedCards.add(c);
                found++;
            } else
                remainingCards.add(c);
        }
        if (found != cardIds.size()) throw new CustomException(404, "Player possesses no such card");
        round.getPlayedCards().put(getNicknameFromId(playerId), playedCards);
        player.setHand(remainingCards);
    }

    public Player getTurnHolder() { // todo can optimize
        for (Player p : playerList.values()) {
            if (p.isMyTurn()) return p;
        }
        return null;
    }

    public void nextBlackCard() {
        round.setCurrentBlackCard(deck.drawBlackCard());
        round.setPlayedCards(new HashMap<>());
    }

    private String getNicknameFromId(String playerId) throws CustomException {
        Player player = playerList.get(playerId);
        if (player == null) throw new CustomException(404, "Player not found");
        return player.getNickname();
    }

    public Player playerFromNickname(String nickname) {
        Optional<Player> player = playerList.values().stream().filter(p -> p.getNickname().equals(nickname)).findFirst();
        return player.orElse(null);
    }
}
