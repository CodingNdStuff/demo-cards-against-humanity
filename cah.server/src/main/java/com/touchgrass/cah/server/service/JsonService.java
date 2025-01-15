package com.touchgrass.cah.server.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.touchgrass.cah.server.model.BlackCard;
import com.touchgrass.cah.server.model.Card;
import com.touchgrass.cah.server.model.WhiteCard;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.lang.reflect.Array;
import java.util.ArrayList;

@Service
public class JsonService {
    private final ObjectMapper objectMapper;
    private final ResourceLoader resourceLoader;

    @Autowired
    public JsonService(ObjectMapper objectMapper, ResourceLoader resourceLoader) {
        this.objectMapper = objectMapper; // Use the injected ObjectMapper
        this.resourceLoader = resourceLoader; // Use the injected ResourceLoader
    }

    public ArrayList<BlackCard> getAllBlackCards() {
        ArrayList<BlackCard> blackCards = new ArrayList<>();
        try {
            blackCards.addAll(_getCardsFromJson("BaseBlackCards.json", BlackCard.class));
            blackCards.addAll(_getCardsFromJson("AdditionalBlackCards.json", BlackCard.class));
        } catch (IOException e) {

        }
        return blackCards;
    }

    public ArrayList<WhiteCard> getAlWhiteCards() {
        ArrayList<WhiteCard> whiteCards = new ArrayList<>();
        try {
            whiteCards.addAll(_getCardsFromJson("BaseWhiteCards.json", WhiteCard.class));
            whiteCards.addAll(_getCardsFromJson("AdditionalWhiteCards.json", WhiteCard.class));
        } catch (IOException e) {

        }
        return whiteCards;
    }

    private <T> ArrayList<T> _getCardsFromJson(String path, Class<T> cardType) throws IOException {
        Resource resource = resourceLoader.getResource("classpath:cards/" + path);
        if (!resource.exists()) {
            System.out.println("Resource not found: " + path);
            return new ArrayList<>();
        }
        return objectMapper.readValue(resource.getInputStream(),
                objectMapper.getTypeFactory().constructCollectionType(ArrayList.class, cardType));
    }

}

