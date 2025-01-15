package com.touchgrass.cah.server.model;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CustomException extends Exception {
    private int code;
    private String reason;
}
