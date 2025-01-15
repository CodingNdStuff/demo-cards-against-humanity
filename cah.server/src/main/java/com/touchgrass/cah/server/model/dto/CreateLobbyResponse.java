package com.touchgrass.cah.server.model.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class CreateLobbyResponse {
    @NotBlank
    @Size(min = 1, max = 32)
    private String lobbyId;
    @NotBlank
    @Size(min = 1, max = 32)
    private String playerId;
}
