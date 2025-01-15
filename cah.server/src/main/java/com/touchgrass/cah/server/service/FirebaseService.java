package com.touchgrass.cah.server.service;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.touchgrass.cah.server.model.Lobby;
import com.touchgrass.cah.server.model.Player;
import com.touchgrass.cah.server.model.dto.LobbyDto;
import org.springframework.stereotype.Service;

@Service
public class FirebaseService {

    private final FirebaseDatabase database;

    public FirebaseService() {
        this.database = FirebaseDatabase.getInstance();
    }

    public void publishLobbyData(Lobby lobby) {
        LobbyDto lobbyDto = new LobbyDto(lobby);
        publishJsonToPath("/" + lobby.getId() + "/lobbyData", lobbyDto);
    }

    public void publishHandData(String lobbyId, Player player) {
        publishJsonToPath("/" + lobbyId + "/hands/" + player.getId(), player.getHand());
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
