package com.touchgrass.cah.server.model;

public enum LobbyStatus {
    open(0),
    initial(1),
    play(2),
    voting(3),
    prep(4),
    closed(5);

    private int id; // todo is this useful?
    LobbyStatus(int id) {
        this.id = id;
    }

}
