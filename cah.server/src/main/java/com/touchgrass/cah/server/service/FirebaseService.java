package com.touchgrass.cah.server.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.touchgrass.cah.server.model.CustomException;
import com.touchgrass.cah.server.model.Lobby;
import com.touchgrass.cah.server.model.Player;
import com.touchgrass.cah.server.model.dto.LobbyDto;
import com.touchgrass.cah.server.model.dto.PlayerDto;
import org.checkerframework.checker.units.qual.A;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Service
public class FirebaseService {

    private final FirebaseDatabase database;

    public FirebaseService() {
        // Initialize Firebase database
        this.database = FirebaseDatabase.getInstance();
    }

    public void publishLobbyData(Lobby lobby) {
        LobbyDto lobbyDto = new LobbyDto(lobby);
        publishJsonToPath("/" + lobby.getId(), lobbyDto);
    }

    public void deleteLobbyData(String lobbyId) {
        DatabaseReference ref = database.getReference("/" + lobbyId);
        ref.removeValue((databaseError, databaseReference) -> {
            System.out.println(databaseError);
        });
    }

    private void publishJsonToPath(String path, Object data) {
        DatabaseReference ref = database.getReference(path);
        ref.setValueAsync(data);
    }
}
