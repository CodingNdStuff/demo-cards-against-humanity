package com.touchgrass.cah.server.model;


import lombok.*;

@Getter
@AllArgsConstructor
@ToString
public class BlackCard implements Card {
    private int id;
    private String text;
    private int numberOfBlanks;
}
