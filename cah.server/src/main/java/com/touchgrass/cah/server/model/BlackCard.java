package com.touchgrass.cah.server.model;


import lombok.*;

@AllArgsConstructor
@ToString
@Getter
@Setter
public class BlackCard implements Card {
    private int id;
    private String text;
    private int numberOfBlanks;
}
