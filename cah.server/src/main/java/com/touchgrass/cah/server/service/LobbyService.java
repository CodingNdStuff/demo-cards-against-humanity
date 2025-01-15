package com.touchgrass.cah.server.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.touchgrass.cah.server.model.*;
import com.touchgrass.cah.server.utils.Constants;
import jakarta.validation.constraints.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class LobbyService {

    @Autowired
    private JsonService jsonService;

    private final Map<String, Lobby> lobbies = new HashMap<>();

    //region actions
    public String createLobby(@NotBlank @Size(min = 1, max = 32) String playerId, @NotBlank @Size(min = 1, max = 16) String nickname, @Min(15) @Max(60) int roundDuration, @Min(1) @Max(15) int maxRoundNumber) throws CustomException {
        System.out.println("Creating lobby");
        if (lobbies.size() >= Constants.MAX_LOBBIES) throw new CustomException(500, "Service is too busy, retry later");
        Lobby lobby = new Lobby(roundDuration, maxRoundNumber, new Player(playerId, nickname), new Deck(jsonService.getAllBlackCards(), jsonService.getAlWhiteCards()));
        lobbies.put(lobby.getId(), lobby);
        System.out.println("Lobby created " + lobby.getId() + ", " + lobbies.size() + " lobbies active");
        return lobby.getId();
    }

    public void joinLobby(String lobbyId, String playerId, String nickname) throws CustomException {
        System.out.println("Player " + nickname + " (" + playerId + ") joining the lobby " + lobbyId);
        Lobby lobby = getLobbyOrThrow(lobbyId);

        if (lobby.getStatus() != LobbyStatus.open) {
            throw new CustomException(403, "Cannot join a closed or ongoing lobby.");
        }

        if (lobby.getPlayerList().get(playerId) != null) {
            throw new CustomException(409, "Player already in lobby");
        }

        System.out.println("Player " + nickname + " (" + playerId + ") successfully joined the lobby " + lobbyId);
        lobby.addPlayer(new Player(playerId, nickname));
    }

    public void setPlayerReady(String lobbyId, String playerId) throws CustomException {
        System.out.println("Setting Player " + " (" + playerId + ") ready in lobby " + lobbyId);
        Lobby lobby = getLobbyOrThrow(lobbyId);

        if (lobby.getStatus() != LobbyStatus.open && lobby.getStatus() != LobbyStatus.prep) {
            throw new CustomException(409, "Lobby status does not currently allow setting players ready");
        }

        lobby.setPlayerReady(playerId);
        System.out.println("Player " + lobby.getPlayerList().get(playerId) + " (" + playerId + ") is now ready in lobby " + lobbyId);
        if (lobby.getPlayerList().size() >= Constants.MIN_PLAYERS_LOBBY) { // Possibly start the game
            if (lobby.checkAllReady()) {
                System.out.println("All players are ready");
                if (lobby.getStatus() == LobbyStatus.open) {
                    _startGame(lobby);
                } else if (lobby.getStatus() == LobbyStatus.prep) {
                    _prepareNextRound(lobby);
                }
            }
        }
    }

    public void playCard(@Size(min = 5, max = 5) String lobbyId, @Size(min = 1, max = 32) String playerId, @NotNull @Size(min = 1) List<@NotNull Integer> cardIds) throws CustomException {
        System.out.println("Player " + " (" + playerId + ") attempts to play card(s) " + cardIds + " in lobby " + lobbyId);
        Lobby lobby = getLobbyOrThrow(lobbyId);
        if (lobby.getStatus() != LobbyStatus.play) throw new CustomException(409, "Cannot play a card right now");
        if (cardIds.size() != lobby.getRound().getCurrentBlackCard().getNumberOfBlanks())
            throw new CustomException(409, "A wrong number of white cards were provided");
        Player player = lobby.getPlayerList().get(playerId);
        if (player == null)
            throw new CustomException(404, "Player not found");
        if (player.isMyTurn())
            throw new CustomException(409, "Cannot play a card right now");

        lobby.playCard(playerId, cardIds);
        lobby.setPlayerReady(playerId);
        //publishEncoded(lobbyId, lobby.getOngoingLobbyData());
        System.out.println("Player " + lobby.getPlayerList().get(playerId) + " (" + playerId + ") played card(s) " + cardIds + " in lobby " + lobbyId);
        if (lobby.checkAllReady()) {
            System.out.println("All players are ready");
            _startVoting(lobby);
        }
    }

    public void voteWinner(@Size(min = 5, max = 5) String lobbyId, @Size(min = 1, max = 32) String playerId, @NotBlank @Size(min = 1, max = 32) String votedPlayerId) throws CustomException {
        System.out.println("Player (" + playerId + ") attempts to vote " + votedPlayerId + " in lobby " + lobbyId);
        Lobby lobby = getLobbyOrThrow(lobbyId);
        Player votingPlayer = lobby.getPlayerList().get(playerId);
        Player votedPlayer = lobby.getPlayerList().get(votedPlayerId);

        if(votingPlayer == null || votedPlayer == null) {
            throw new CustomException(404, "Player not found");
        }

        if(!votingPlayer.isMyTurn()) {
            throw new CustomException(401, "Unauthorized");
        }

        votingPlayer.setMyTurn(false);
        votedPlayer.setMyTurn(true);
        votedPlayer.addScore(100);
        votedPlayer.setReady(true);
        lobby.setCurrentRound(lobby.getCurrentRound() + 1);
        System.out.println("Player (" + playerId + ") " + votingPlayer.getNickname() + " voted (" + votedPlayer + ") " + votedPlayer.getNickname() + " in lobby " + lobbyId);

        if(lobby.getCurrentRound() < lobby.getMaxRoundNumber())
            _prepareNextRound(lobby);
        else
            _close(lobby);
    }

    //endregion

    //region lobby status changes
    private void _startGame(Lobby lobby) {
        System.out.println("Lobby " + lobby.getId() + " is starting a new round");
        lobby.setStatus(LobbyStatus.play);
        lobby.resetAllPlayerReady();
        lobby.refillHands();
        lobby.getTurnHolder().setReady(true);
    }

    private void _startVoting(Lobby lobby) {
        System.out.println("Lobby " + lobby.getId() + " is voting");
        lobby.setStatus(LobbyStatus.voting);
        lobby.resetAllPlayerReady();
        // shuffle played cards
        // publish

        checkVotingHostDisconnection(lobby);
    }

    private void _prepareNextRound(Lobby lobby) {
        System.out.println("Lobby " + lobby.getId() + " is preparing for a new round");

        if(lobby.getStatus() == LobbyStatus.voting){
            lobby.setStatus(LobbyStatus.prep);
            lobby.resetAllPlayerReady();
        }else if(lobby.getStatus() == LobbyStatus.prep){
            lobby.setStatus(LobbyStatus.play);
            lobby.resetAllPlayerReady();
            lobby.refillHands();
            lobby.nextBlackCard();
            // publish player
        }
        // publish lobby
    }

    private void _close (Lobby lobby) {
        System.out.println("Lobby " + lobby.getId() + " is closing");
        lobby.setStatus(LobbyStatus.closed);
        // publish lobby
        // publish player
        lobbies.remove(lobby.getId());
        System.out.println("Lobby " + lobby.getId() + " is closed, " + lobbies.size() + " lobbies remaining");
    }

    //endregion

    //region utility

    public String getLobbyInfo(@Size(min = 5, max = 5) String lobbyId) throws CustomException {
        Lobby lobby = getLobbyOrThrow(lobbyId);
        ObjectMapper mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        try {
            return mapper.writeValueAsString(lobby);
        } catch (JsonProcessingException e) {
            System.out.println(e.getMessage());
            throw new CustomException(500, "Unable to process lobby information");
        }
    }

    private void checkVotingHostDisconnection(Lobby lobby) { //todo test in real scenario
        //if the holder of the token disconnects, after 10 seconds a random player gets voted artificially
        if (lobby.getTurnHolder() != null && lobby.getPlayerList().containsKey(lobby.getTurnHolder().getId())) return;
        System.out.println("Disconnection during voting occurred in lobby " + lobby.getId() + ", preparing automated voting procedure");
        int index = ThreadLocalRandom.current().nextInt(lobby.getPlayerList().size());

        Player player = lobby.getPlayerList().values().stream().toList().get(index);
        player.setMyTurn(true);

        // Schedule a task to call the `voteWinner` method after 10 seconds
        new java.util.Timer().schedule(
                new java.util.TimerTask() {
                    @Override
                    public void run() {
                        System.out.println("Disconnection during voting occurred in lobby " + lobby.getId() + ", automatically voting " + player.getNickname() + " (" + player.getId() + ")");
                        try {
                            voteWinner(lobby.getId(), player.getId(), player.getId());
                        } catch (CustomException e) {
                            throw new RuntimeException(e);
                        }
                    }
                },
                10_000 // 10 seconds in milliseconds
        );
    }

    private void deleteLobby(String lobbyId) throws CustomException {
        System.out.println("Deleting lobby " + lobbyId);
        if (!lobbies.containsKey(lobbyId)) {
            throw new CustomException(404, "Lobby not found.");
        }
        lobbies.remove(lobbyId);
    }

    private Lobby getLobbyOrThrow(String lobbyId) throws CustomException {
        Lobby lobby = lobbies.get(lobbyId);
        if (lobby == null) {
            throw new CustomException(404, "Lobby not found.");
        }
        return lobby;
    }

    //endregion

}



