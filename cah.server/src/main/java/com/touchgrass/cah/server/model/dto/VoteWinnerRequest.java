package com.touchgrass.cah.server.model.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class VoteWinnerRequest {
    @NotBlank
    @Size(min = 1, max = 32)
    private String votedPlayerId;
}
