package com.touchgrass.cah.server.model;

import com.touchgrass.cah.server.service.JsonService;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Random;


@NoArgsConstructor
@AllArgsConstructor
public class Deck {
    private ArrayList<BlackCard> blackCards = new ArrayList<>();
    private ArrayList<WhiteCard> whiteCards = new ArrayList<>();

    public BlackCard drawBlackCard() {
        if (blackCards.isEmpty()) {
            System.out.println("Black Deck is empty");
            return null;
        }

        Random rand = new Random();
        int cardIndex = rand.nextInt(blackCards.size() - 1);
        BlackCard drawnCard = blackCards.get(cardIndex);
        blackCards.remove(cardIndex);
        System.out.println("Pulled a new Black Card " + drawnCard.getId() + " " + drawnCard.getText().substring(0, 15) + "...");
        return drawnCard;
    }

    public WhiteCard drawWhiteCard() {
        if (whiteCards.isEmpty()) {
            System.out.println("White Deck is empty"); //todo what consequences would this have if "play again with different cards" would be implemented, probably a NullPtr
            return null;
        }
        Random rand = new Random();
        int cardIndex = rand.nextInt(whiteCards.size() - 1);
        WhiteCard drawnCard = whiteCards.get(cardIndex);
        whiteCards.remove(cardIndex);
        System.out.println("Pulled a new White Card " + drawnCard.getId() + " " + drawnCard.getText().substring(0, 15) + "...");
        return drawnCard;
    }
}
