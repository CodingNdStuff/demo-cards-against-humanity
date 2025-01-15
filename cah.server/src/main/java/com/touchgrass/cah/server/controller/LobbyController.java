package com.touchgrass.cah.server.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.touchgrass.cah.server.model.*;
import com.touchgrass.cah.server.model.dto.CreateLobbyRequest;
import com.touchgrass.cah.server.model.dto.JoinLobbyRequest;
import com.touchgrass.cah.server.model.dto.PlayCardRequest;
import com.touchgrass.cah.server.model.dto.VoteWinnerRequest;
import com.touchgrass.cah.server.service.LobbyService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Size;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;


@RestController
//@EnableWebMvc
@RequestMapping("/api")
public class LobbyController {

    @Autowired
    private LobbyService lobbyService;

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
            String lobbyId = lobbyService.createLobby(
                    lobbyRequest.getPlayerId(),
                    lobbyRequest.getNickname(),
                    lobbyRequest.getRoundDuration(),
                    lobbyRequest.getMaxRoundNumber());
            return ResponseEntity.status(201).body(Map.of("lobbyId", lobbyId));
        } catch (CustomException e) {
            return ResponseEntity.status(e.getCode()).body(e.getMessage());
        }
    }

    @PostMapping("/joinLobby/{lobbyId}")
    public ResponseEntity<?> joinLobby(
            @PathVariable @Size(min = 5, max = 5) String lobbyId,
            @RequestBody @Valid JoinLobbyRequest joinLobbyRequest) {
        try {
            lobbyService.joinLobby(lobbyId, joinLobbyRequest.getPlayerId(), joinLobbyRequest.getNickname());
            return ResponseEntity.status(201).build();
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

    /*
    @PostMapping("/voteWinner/{lobbyId}/{playerId}")
    public ResponseEntity<?> voteWinner(
            @PathVariable @Size(min = 5, max = 5) String lobbyId,
            @PathVariable @Size(min = 1, max = 32) String playerId,
            @RequestBody @Valid VoteWinnerRequest voteWinnerRequest) {
        try {
            lobbyService.voteWinner(lobbyId, playerId, voteWinnerRequest.getVotedPlayerId());
            return ResponseEntity.status(201).build();
        } catch (Exception e) {
            if (e.getMessage().equals("404")) {
                return ResponseEntity.status(404).build();
            }
            if (e.getMessage().equals("403")) {
                return ResponseEntity.status(403).build();
            }
            return ResponseEntity.status(500).build();
        }
    }
 */
}

