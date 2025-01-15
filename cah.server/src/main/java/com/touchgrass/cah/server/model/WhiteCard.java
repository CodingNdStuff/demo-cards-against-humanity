package com.touchgrass.cah.server.model;

import lombok.*;

@AllArgsConstructor
@ToString
@Getter
@Setter
public class WhiteCard implements Card {
    private int id;
    private String text;
}
