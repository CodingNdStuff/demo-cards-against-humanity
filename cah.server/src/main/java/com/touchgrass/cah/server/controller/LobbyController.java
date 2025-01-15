package com.touchgrass.cah.server.controller;

import com.touchgrass.cah.server.model.*;
import com.touchgrass.cah.server.model.dto.*;
import com.touchgrass.cah.server.service.FirebaseService;
import com.touchgrass.cah.server.service.LobbyService;
import com.touchgrass.cah.server.utils.Constants;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Size;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;


@RestController
//@EnableWebMvc
@RequestMapping("/api")
public class LobbyController {

    @Autowired
    private LobbyService lobbyService;
    @Autowired
    private FirebaseService firebaseService;

    @RequestMapping(path = "/lobbyStatus/{lobbyId}", method = RequestMethod.GET)
    public ResponseEntity<?> lobbyStatus(@PathVariable @Size(min = 5, max = 5) String lobbyId) {
        try {
            String json = lobbyService.getLobbyInfo(lobbyId);
            return ResponseEntity.status(200).body(json);
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }

    @PostMapping("/createLobby")
    public ResponseEntity<?> createLobby(
            @RequestBody @Valid CreateLobbyRequest lobbyRequest) {
        try {
            String playerId = "sdq12d"; //UUID.randomUUID().toString();
            String lobbyId = lobbyService.createLobby(
                    playerId,
                    lobbyRequest.getNickname(),
                    lobbyRequest.getRoundDuration(),
                    lobbyRequest.getMaxRoundNumber());
            CreateLobbyResponse responseBody = new CreateLobbyResponse();
            responseBody.setPlayerId(playerId);
            responseBody.setLobbyId(lobbyId);
            return ResponseEntity.status(201).body(responseBody);
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }

    @PostMapping("/joinLobby/{lobbyId}")
    public ResponseEntity<?> joinLobby(
            @PathVariable @Size(min = 5, max = 5) String lobbyId,
            @RequestBody @Valid JoinLobbyRequest joinLobbyRequest) {
        try {
            String playerId = lobbyService.joinLobby(lobbyId, joinLobbyRequest.getNickname());
            JoinLobbyResponse responseBody = new JoinLobbyResponse();
            responseBody.setPlayerId(playerId);
            return ResponseEntity.status(201).body(responseBody);
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }

    @PostMapping("/setPlayerReady/{lobbyId}/{playerId}")
    public ResponseEntity<?> setPlayerReady(
            @PathVariable @Size(min = 5, max = 5) String lobbyId,
            @PathVariable @Size(min = 1, max = 32) String playerId) {
        try {
            lobbyService.setPlayerReady(lobbyId, playerId);
            return ResponseEntity.status(201).build();
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }

    @PostMapping("/playCard/{lobbyId}/{playerId}")
    public ResponseEntity<?> playCard(
            @PathVariable @Size(min = 5, max = 5) String lobbyId,
            @PathVariable @Size(min = 1, max = 32) String playerId,
            @RequestBody @Valid PlayCardRequest playCardRequest) {
        try {
            lobbyService.playCard(lobbyId, playerId, playCardRequest.getCardIds());
            return ResponseEntity.status(201).build();
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }

    @PostMapping("/voteWinner/{lobbyId}/{playerId}")
    public ResponseEntity<?> voteWinner(
            @PathVariable @Size(min = 5, max = 5) String lobbyId,
            @PathVariable @Size(min = 1, max = 32) String playerId,
            @RequestBody @Valid VoteWinnerRequest voteWinnerRequest) {
        try {
            lobbyService.voteWinner(lobbyId, playerId, voteWinnerRequest.getVotedPlayerNickname());
            return ResponseEntity.status(201).build();
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }
}

