package com.touchgrass.cah.server.model;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class WhiteCard implements Card {
    private String id;
    private String text;
}
