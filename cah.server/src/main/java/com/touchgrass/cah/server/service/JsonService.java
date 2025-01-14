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

    public ArrayList<WhiteCard> getWhiteCardsFromJson(String path) throws IOException {
        Resource resource = resourceLoader.getResource("classpath:cards/" + path);
        return objectMapper.readValue(resource.getInputStream(),
                objectMapper.getTypeFactory().constructCollectionType(ArrayList.class, WhiteCard.class));
    }

    public ArrayList<BlackCard> getBlackCardsFromJson(String path) throws IOException {
        Resource resource = resourceLoader.getResource("classpath:cards/" + path);
        if (!resource.exists()) {
            System.out.println("Resource not found: " + path);  // Log if the resource does not exist
            return new ArrayList<>(); // Return an empty list if the file is not found
        }
        return objectMapper.readValue(resource.getInputStream(),
                objectMapper.getTypeFactory().constructCollectionType(ArrayList.class, BlackCard.class));
    }
}

