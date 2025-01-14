package com.touchgrass.cah.server.controller;

import com.touchgrass.cah.server.model.BlackCard;
import com.touchgrass.cah.server.model.Deck;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import java.util.HashMap;
import java.util.Map;


@RestController
//@EnableWebMvc
public class LobbyController {
    @Autowired
    private Deck deck;

    @RequestMapping(path = "/ping", method = RequestMethod.GET)
    public Map<String, String> ping() {
        Map<String, String> pong = new HashMap<>();
        BlackCard card = deck.drawBlackCard();
        if(card == null) return pong;
        pong.put("id", card.getId());
        pong.put("text", card.getText());
        pong.put("numberOfBlanks", String.valueOf(card.getNumberOfBlanks()));
        return pong;
    }
}
