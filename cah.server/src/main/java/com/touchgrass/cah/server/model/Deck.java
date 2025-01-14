package com.touchgrass.cah.server.model;

import com.touchgrass.cah.server.service.JsonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Random;


@Component
public class Deck {
    private final ArrayList<BlackCard> blackCards;
    private final ArrayList<WhiteCard> whiteCards;

    @Autowired
    public Deck(JsonService jsonService) {
        blackCards =  new ArrayList<>();
        whiteCards = new ArrayList<>();
        try {
            blackCards.addAll(
                    jsonService.getBlackCardsFromJson("BaseBlackCards.json"));
            blackCards.addAll(
                    jsonService.getBlackCardsFromJson("AdditionalBlackCards.json"));

            whiteCards.addAll(
                    jsonService.getWhiteCardsFromJson("BaseWhiteCards.json"));
            whiteCards.addAll(
                    jsonService.getWhiteCardsFromJson("AdditionalWhiteCards.json"));
        } catch (Exception e) {
            System.out.println("Unable to load cards from resources : " + e.getMessage());
        }
    }

    public BlackCard drawBlackCard() {
        if (blackCards.isEmpty()) {
            System.out.println("Black Deck is empty");
            return null;
        }
        System.out.println("Pulling a new Black Card");
        Random rand = new Random();
        int cardIndex = rand.nextInt(blackCards.size() - 1);
        BlackCard drawnCard = blackCards.get(cardIndex);
        blackCards.remove(cardIndex);
        return drawnCard;
    }

    public WhiteCard drawWhiteCard() {
        if (whiteCards.isEmpty()) {
            System.out.println("White Deck is empty");
            return null;
        }
        System.out.println("Pulling a new White Card");
        Random rand = new Random();
        int cardIndex = rand.nextInt(whiteCards.size() - 1);
        WhiteCard drawnCard = whiteCards.get(cardIndex);
        whiteCards.remove(cardIndex);
        return drawnCard;
    }
}
