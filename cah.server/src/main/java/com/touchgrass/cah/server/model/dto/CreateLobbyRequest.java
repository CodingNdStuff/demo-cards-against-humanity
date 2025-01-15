package com.touchgrass.cah.server.model.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CreateLobbyRequest {
    @NotBlank
    @Size(min = 1, max = 16)
    private String nickname;

    @Min(15)
    @Max(60)
    private int roundDuration;

    @Min(1)
    @Max(15)
    private int maxRoundNumber;
}
