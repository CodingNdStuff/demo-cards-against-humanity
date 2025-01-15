package com.touchgrass.cah.server.service;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.touchgrass.cah.server.model.Lobby;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class FirebaseService {

    private final FirebaseDatabase database;

    public FirebaseService() {
        // Initialize Firebase database
        this.database = FirebaseDatabase.getInstance();
    }

    public void publishLobbyData(Lobby lobby){
        HashMap<String, Object> lobbyJson = new HashMap<>();
        lobbyJson.put("id", lobby.getId());
        publishJsonToPath("/lobbyTest", lobbyJson);
    }

    private void publishJsonToPath(String path, Map<String, Object> data) {
        DatabaseReference ref = database.getReference(path);
        ref.setValueAsync(data);
    }
}
